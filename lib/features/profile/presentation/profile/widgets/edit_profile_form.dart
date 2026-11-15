import 'package:flutter/material.dart';
import 'package:nutri_vision/core/utils/validators.dart';
import 'package:nutri_vision/features/profile/domain/entities/user_profile.dart';

/// Shown in a sheet/dialog. Pops with the updated [UserProfile].
class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.profile});
  final UserProfile profile;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.fullName);
  late final _phone =
      TextEditingController(text: widget.profile.phoneNumber ?? '');
  late final _bio = TextEditingController(text: widget.profile.bio ?? '');

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phone.text.trim();
    final bio = _bio.text.trim();
    Navigator.pop(
      context,
      widget.profile.copyWith(
        fullName: _name.text.trim(),
        phoneNumber: phone,
        bio: bio,
        clearPhoneNumber: phone.isEmpty,
        clearBio: bio.isEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit profile',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => Validators.required(v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? null : Validators.phone(v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bio,
              maxLines: 3,
              maxLength: 160,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
