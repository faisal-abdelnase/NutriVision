import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/widgets/content_container.dart';
import 'package:nutri_vision/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:nutri_vision/features/authentication/presentation/cubit/auth_state.dart';
import 'package:nutri_vision/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nutri_vision/features/profile/presentation/cubit/profile_state.dart';

import '../widgets/delete_account_dialog.dart';
import '../widgets/language_selector.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_mode_selector.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _goToAuth(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.authentication,
      (_) => false,
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = context.read<AuthCubit>();
    await auth.signOut();
    if (!context.mounted) return;
    if (auth.state is AuthUnauthenticated) {
      _goToAuth(context);
    } else if (auth.state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((auth.state as AuthError).message)),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
    if (password == null || !context.mounted) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cubit = context.read<ProfileCubit>();
    await cubit.deleteAccount(userId: userId, reauthenticationToken: password);
    if (!context.mounted) return;

    final state = cubit.state;
    if (state.status == ProfileStatus.success && state.profile == null) {
      _goToAuth(context);
    } else if (state.status == ProfileStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Could not delete account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ContentContainer(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const SettingsSection(
              title: 'Appearance',
              children: [ThemeModeSelector()],
            ),
            const SettingsSection(
              title: 'Language',
              children: [LanguageSelector()],
            ),
            SettingsSection(
              title: 'Notifications',
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final profile = state.profile;
                    return SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push notifications',
                      trailing: Switch(
                        value: profile?.notificationsEnabled ?? true,
                        onChanged: profile == null
                            ? null
                            : (v) => context.read<ProfileCubit>().updateProfile(
                                  profile.copyWith(notificationsEnabled: v),
                                ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.logout,
                  title: 'Sign out',
                  onTap: () => _signOut(context),
                ),
                SettingsTile(
                  icon: Icons.delete_forever_outlined,
                  title: 'Delete account',
                  destructive: true,
                  onTap: () => _deleteAccount(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
