
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/ai_coach_injection.dart';
import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/coach_message.dart';
import '../cubit/ai_coach_cubit.dart';
import '../cubit/ai_coach_state.dart';

class AiCoachTestScreen extends StatelessWidget {
  const AiCoachTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AiCoachCubit>(),
      child: const _AiCoachView(),
    );
  }
}

class _AiCoachView extends StatefulWidget {
  const _AiCoachView();

  @override
  State<_AiCoachView> createState() => _AiCoachViewState();
}

class _AiCoachViewState extends State<_AiCoachView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // String? get _userId => FirebaseAuth.instance.currentUser?.uid;
  final _userId = "nPnM6XrOTMfNSruWuB3kqZeBdfz1";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = _userId;
      if (userId != null && mounted) {
        context.read<AiCoachCubit>().loadConversations(
              userId: userId,
            );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _createConversation() async {
    final userId = "nPnM6XrOTMfNSruWuB3kqZeBdfz1";

    // if (userId == null) {
    //   _showMessage('Please sign in before testing AI Coach.');
    //   return;
    // }

    final cubit = context.read<AiCoachCubit>();

    final conversation = await cubit.createConversation(
      userId: userId,
      title: 'Nutrition consultation',
    );

    if (!mounted || conversation == null) return;

    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _openConversation(
    CoachConversation conversation,
  ) async {
    final userId = _userId;
    if (userId == null) return;

    Navigator.of(context).pop();

    await context.read<AiCoachCubit>().openConversation(
          userId: userId,
          conversation: conversation,
        );

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final userId = _userId;
    final text = _messageController.text.trim();

    if (userId == null) {
      _showMessage('Please sign in before sending a message.');
      return;
    }

    if (text.isEmpty) return;

    final cubit = context.read<AiCoachCubit>();

    if (cubit.state.currentConversation == null) {
      _showMessage('Create or select a conversation first.');
      return;
    }

    _messageController.clear();
    FocusScope.of(context).unfocus();

    await cubit.sendMessage(
      userId: userId,
      message: text,
    );

    _scrollToBottom();
  }

  Future<void> _loadNutritionAdvice() async {
    final userId = _userId;
    if (userId == null) {
      _showMessage('Please sign in first.');
      return;
    }

    await context.read<AiCoachCubit>().loadNutritionAdvice(
          userId: userId,
          dietaryPreferences: const [],
          allergies: const [],
          referencedMealIds: const [],
          goal: 'Healthy eating',
        );
  }

  Future<void> _deleteConversation(
    CoachConversation conversation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete conversation?'),
        content: Text(
          'Delete "${conversation.title}" and its messages?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    final userId = _userId;
    if (userId == null) return;

    await context.read<AiCoachCubit>().deleteConversation(
          userId: userId,
          conversationId: conversation.id,
        );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _userId;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('NutriVision AI Coach')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'You need to sign in with Firebase Authentication '
              'before testing AI Coach.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return BlocConsumer<AiCoachCubit, AiCoachState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }

        if (state.errorMessage != null) {
          _showMessage(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final conversation = state.currentConversation;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NutriVision AI',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  conversation?.title ?? 'Nutrition Assistant',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Nutrition advice',
                onPressed: state.isSending
                    ? null
                    : _loadNutritionAdvice,
                icon: const Icon(Icons.health_and_safety_outlined),
              ),
              IconButton(
                tooltip: 'New conversation',
                onPressed: _createConversation,
                icon: const Icon(Icons.add_comment_outlined),
              ),
            ],
          ),
          drawer: _buildDrawer(state),
          body: Column(
            children: [
              _buildConnectionInfo(state),
              if (state.nutritionAdvice != null)
                _buildNutritionAdvice(state),
              Expanded(
                child: _buildMessages(state),
              ),
              if (state.isSending) _buildTypingIndicator(),
              _buildComposer(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionInfo(AiCoachState state) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: colors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Nutrition Assistant',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  state.currentConversation == null
                      ? 'Create a conversation to start testing.'
                      : 'Ask about meals, calories, or healthy habits.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(AiCoachState state) {
    if (state.currentConversation == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Start your AI conversation',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a new conversation, then ask Gemini '
                'a nutrition question.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _createConversation,
                icon: const Icon(Icons.add),
                label: const Text('New conversation'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.history),
                label: const Text('View previous conversations'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == AiCoachStatus.loading &&
        state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 52,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              const Text('Your conversation is ready.'),
              const SizedBox(height: 6),
              const Text(
                'Try: "Suggest a healthy breakfast with eggs."',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return _MessageBubble(message: message);
      },
    );
  }

  Widget _buildTypingIndicator() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Gemini is thinking...'),
        ],
      ),
    );
  }

  Widget _buildComposer(AiCoachState state) {
    final colors = Theme.of(context).colorScheme;
    final canSend = state.currentConversation != null &&
        !state.isSending;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: colors.outlineVariant),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) {
                  // Enter inserts a new line; use the send button.
                },
                decoration: InputDecoration(
                  hintText: state.currentConversation == null
                      ? 'Create a conversation first...'
                      : 'Ask your nutrition coach...',
                  filled: true,
                  fillColor: colors.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Send message',
              onPressed: canSend ? _sendMessage : null,
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(AiCoachState state) {
    final colors = Theme.of(context).colorScheme;
    final currentId = state.currentConversation?.id;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: colors.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 36,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AI Coach',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text('${state.conversations.length} conversations'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_comment_outlined),
              title: const Text('New conversation'),
              onTap: () {
                Navigator.of(context).pop();
                _createConversation();
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: state.conversations.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No conversations yet.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation =
                            state.conversations[index];

                        return ListTile(
                          selected: conversation.id == currentId,
                          leading: const Icon(Icons.chat_outlined),
                          title: Text(
                            conversation.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            conversation.lastMessagePreview ??
                                'No messages yet',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _openConversation(conversation),
                          trailing: IconButton(
                            tooltip: 'Delete conversation',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _deleteConversation(conversation),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionAdvice(AiCoachState state) {
    final advice = state.nutritionAdvice!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  advice.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                tooltip: 'Close advice',
                onPressed: () {
                  context.read<AiCoachCubit>().clearError();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(advice.content),
          if (advice.recommendations.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Recommendations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...advice.recommendations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• $item'),
              ),
            ),
          ],
          if (advice.warnings.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Warnings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...advice.warnings.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• $item'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final CoachMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isUser = message.role == CoachMessageRole.user;

    final bubbleColor =
        isUser ? colors.primary : colors.surfaceContainerHighest;
    final textColor =
        isUser ? colors.onPrimary : colors.onSurface;

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'You' : 'NutriVision AI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            SelectableText(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Text(
                TimeOfDay.fromDateTime(message.createdAt)
                    .format(context),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
