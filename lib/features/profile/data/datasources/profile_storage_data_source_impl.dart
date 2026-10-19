import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'profile_storage_data_source.dart';

class ProfileStorageDataSourceImpl
    implements ProfileStorageDataSource {
  final FirebaseStorage storage;

  ProfileStorageDataSourceImpl({
    required this.storage,
  });

  Reference _imageRef(String userId) {
    return storage.ref('profile_images/$userId/profile.jpg');
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Profile image file does not exist.');
    }

    final ref = _imageRef(userId);

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  @override
  Future<void> deleteProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    if (imageUrl.isEmpty) return;

    await storage.refFromURL(imageUrl).delete();
  }

  @override
  Future<bool> profileImageExists({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await storage.refFromURL(imageUrl).getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false;
      }
      rethrow;
    }
  }
}