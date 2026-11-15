import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/adaptive/adaptive_dialog.dart' as adaptive;
import 'package:nutri_vision/core/utils/formatters.dart';
import 'package:nutri_vision/core/widgets/content_container.dart';
import 'package:nutri_vision/core/widgets/state_message_view.dart';
import 'package:nutri_vision/features/profile/domain/entities/user_profile.dart';
import 'package:nutri_vision/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nutri_vision/features/profile/presentation/cubit/profile_state.dart';


import '../widgets/edit_profile_form.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';

/// Uses the app-level [ProfileCubit] provided in `app.dart`.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _edit(BuildContext context, UserProfile profile) async {
    final updated = await adaptive.showAdaptiveDialog<UserProfile>(
      context: context,
      builder: (_) => EditProfileForm(profile: profile),
    );
    if (updated != null && context.mounted) {
      context.read<ProfileCubit>().updateProfile(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            curr.status == ProfileStatus.failure && prev.profile != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
          );
        },
        builder: (context, state) {
          final profile = state.profile;

          if (profile == null) {
            if (state.status == ProfileStatus.failure) {
              return StateMessageView(
                icon: Icons.error_outline,
                title: 'Could not load your profile',
                message: state.errorMessage,
                actionLabel: 'Retry',
                onAction: () =>
                    context.read<ProfileCubit>().loadProfile(_userId),
              );
            }
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return const StateMessageView(
              icon: Icons.person_off_outlined,
              title: 'No profile found',
            );
          }

          final busy = state.status == ProfileStatus.updating ||
              state.status == ProfileStatus.uploadingPhoto;

          return ContentContainer(
            maxWidth: 720,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                if (busy) const LinearProgressIndicator(),
                ProfileHeader(
                  profile: profile,
                  onEdit: () => _edit(context, profile),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ProfileInfoTile(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: profile.phoneNumber),
                      const Divider(),
                      ProfileInfoTile(
                          icon: Icons.cake_outlined,
                          label: 'Date of birth',
                          value: profile.dateOfBirth == null
                              ? null
                              : Formatters.date(profile.dateOfBirth!)),
                      const Divider(),
                      ProfileInfoTile(
                          icon: Icons.wc_outlined,
                          label: 'Gender',
                          value: profile.gender),
                      const Divider(),
                      ProfileInfoTile(
                          icon: Icons.info_outline,
                          label: 'Bio',
                          value: profile.bio),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
