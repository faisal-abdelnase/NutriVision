import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/adaptive/adaptive_dialog.dart' as adaptive;
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/responsive/responsive_padding.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';
import '../cubit/ai_coach_cubit.dart';
import '../cubit/ai_coach_state.dart';
import '../widgets/coach_chat_panel.dart';
import '../widgets/coach_context_builder.dart';
import '../widgets/coach_context_sidebar.dart';
import '../widgets/coach_energy_card.dart';
import '../widgets/coach_header.dart';

/// AI nutrition coach screen.
///
/// Real data: conversations, messages and advice come from [AiCoachCubit];
/// today's totals and meals from [DashboardCubit]; targets, allergies and
/// preferences from [NutritionProfileCubit]. No mock data is used.
class AiCoachPage extends StatelessWidget {
  const AiCoachPage({super.key, this.userId});

  /// Defaults to the signed-in Firebase user.
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final uid = userId ?? FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('coachTitle'))),
        body: Center(child: Text(context.tr('coachSignInRequired'))),
      );
    }

    final locator = GetIt.instance;
    final newConversationTitle = context.tr('coachNewConversationTitle');

    return MultiBlocProvider(
      providers: [
        BlocProvider<AiCoachCubit>(
          create: (ctx) => locator<AiCoachCubit>()
            ..startSession(
              userId: uid,
              newConversationTitle: newConversationTitle,
            ),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) => locator<DashboardCubit>()..loadDashboard(userId: uid),
        ),
        BlocProvider<NutritionProfileCubit>(
          create: (_) =>
              locator<NutritionProfileCubit>()..fetchProfile(userId: uid),
        ),
      ],
      child: _AiCoachView(userId: uid),
    );
  }
}

class _AiCoachView extends StatefulWidget {
  const _AiCoachView({required this.userId});

  final String userId;

  @override
  State<_AiCoachView> createState() => _AiCoachViewState();
}

class _AiCoachViewState extends State<_AiCoachView> {
  final TextEditingController _controller = TextEditingController();
  String? _lastSent;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final cubit = context.read<AiCoachCubit>();
    _lastSent = text;
    await cubit.sendMessage(userId: widget.userId, message: text);
    if (!mounted) return;
    if (cubit.state.errorMessage == null) _lastSent = null;
  }

  Future<void> _startNewSession() async {
    await context.read<AiCoachCubit>().createConversation(
          userId: widget.userId,
          title: context.tr('coachNewConversationTitle'),
        );
  }

  void _retryStart() {
    context.read<AiCoachCubit>().startSession(
          userId: widget.userId,
          newConversationTitle: context.tr('coachNewConversationTitle'),
        );
  }

  void _handleError(BuildContext context) {
    // Give a failed message back to the user so nothing is lost.
    final failed = _lastSent;
    if (failed != null && _controller.text.isEmpty) {
      _controller.text = failed;
    }
    _lastSent = null;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.tr('coachRequestFailed'))));

    context.read<AiCoachCubit>().clearError();
  }

  void _openInsights() {
    final aiCubit = context.read<AiCoachCubit>();
    final dashboardCubit = context.read<DashboardCubit>();
    final profileCubit = context.read<NutritionProfileCubit>();

    adaptive.showAdaptiveDialog<void>(
      context: context,
      builder: (sheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: aiCubit),
            BlocProvider.value(value: dashboardCubit),
            BlocProvider.value(value: profileCubit),
          ],
          child: _InsightsSheet(
            userId: widget.userId,
            onPrompt: (prompt) {
              Navigator.of(sheetContext).pop();
              _send(prompt);
            },
          ),
        );
      },
    );
  }

  Widget _chatPanel() {
    return CoachChatPanel(
      userId: widget.userId,
      controller: _controller,
      onSend: _send,
      onRetry: _retryStart,
    );
  }

  Widget _buildCompact(BuildContext context, AppBreakpoint breakpoint) {
    return ResponsivePadding(
      vertical: ThemeDimensions.spaceSm,
      child: Column(
        children: [
          CoachHeader(
            onNewSession: _startNewSession,
            onInsights: _openInsights,
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          Expanded(child: _chatPanel()),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, AppBreakpoint breakpoint) {
    final chatHeight =
        (MediaQuery.sizeOf(context).height * 0.7).clamp(520.0, 820.0).toDouble();

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: ThemeDimensions.contentMaxWidth),
        child: ResponsivePadding(
          vertical: ThemeDimensions.spaceMd,
          child: CoachContextBuilder(
            userId: widget.userId,
            builder: (context, coachContext) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CoachHeader(onNewSession: _startNewSession),
                    const SizedBox(height: ThemeDimensions.spaceLg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              CoachEnergyCard(coachContext: coachContext),
                              const SizedBox(height: ThemeDimensions.spaceLg),
                              SizedBox(height: chatHeight, child: _chatPanel()),
                            ],
                          ),
                        ),
                        const SizedBox(width: ThemeDimensions.gutterDesktop),
                        Expanded(
                          flex: 4,
                          child: CoachContextSidebar(
                            coachContext: coachContext,
                            onPrompt: _send,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiCoachCubit, AiCoachState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, _) => _handleError(context),
      child: Scaffold(
        body: SafeArea(
          child: AppResponsiveBuilder(
            mobile: _buildCompact,
            desktop: _buildDesktop,
          ),
        ),
      ),
    );
  }
}

class _InsightsSheet extends StatelessWidget {
  const _InsightsSheet({required this.userId, required this.onPrompt});

  final String userId;
  final ValueChanged<String> onPrompt;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
        child: CoachContextBuilder(
          userId: userId,
          builder: (context, coachContext) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr('coachInsights'),
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: context.tr('close'),
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeDimensions.spaceSm),
                CoachEnergyCard(coachContext: coachContext),
                const SizedBox(height: ThemeDimensions.spaceMd),
                CoachContextSidebar(
                  coachContext: coachContext,
                  onPrompt: onPrompt,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
