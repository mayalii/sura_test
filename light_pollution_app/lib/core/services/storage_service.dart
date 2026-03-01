import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String path) async {
    if (!await file.exists()) {
      throw Exception('File does not exist: ${file.path}');
    }
    final ref = _storage.ref().child(path);
    final task = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    // Wait for the upload to fully complete
    final snapshot = await task;

    // Verify upload succeeded
    if (snapshot.state != TaskState.success) {
      throw Exception('Upload failed with state: ${snapshot.state}');
    }

    // Get download URL with retry (sometimes needs a moment)
    try {
      return await ref.getDownloadURL();
    } catch (_) {
      // Retry once after a brief pause
      await Future.delayed(const Duration(seconds: 1));
      return await ref.getDownloadURL();
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Image may already be deleted
    }
  }

  Future<List<String>> uploadPostImages(List<File> files, String postId) async {
    final urls = <String>[];
    for (int i = 0; i < files.length; i++) {
      final path = 'posts/$postId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final url = await uploadImage(files[i], path);
      urls.add(url);
    }
    return urls;
  }

  Future<void> deletePostImages(List<String> urls) async {
    for (final url in urls) {
      await deleteImage(url);
    }
  }
}
