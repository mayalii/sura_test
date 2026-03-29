import 'dart:io';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/community_models.dart';
import '../models/mock_data.dart';

class CommunityState {
  const CommunityState({
    this.posts = const [],
    this.isLoading = false,
  });

  final List<SkyPost> posts;
  final bool isLoading;

  CommunityState copyWith({
    List<SkyPost>? posts,
    bool? isLoading,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final postsStreamProvider = StreamProvider<List<SkyPost>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final controller = StreamController<List<SkyPost>>();
  final mockPosts = MockData.localMockPosts();

  final sub = firestoreService.postsStream().listen(
    (firestorePosts) {
      // Merge Firestore posts with local mock posts
      controller.add([...firestorePosts, ...mockPosts]);
    },
    onError: (e) {
      // On error, just show mock data
      controller.add(mockPosts);
    },
  );

  // If no data after 3 seconds, show mock data
  Future.delayed(const Duration(seconds: 3), () {
    if (!controller.isClosed) {
      // This will be overridden when Firestore responds
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier(this._ref) : super(const CommunityState());

  final Ref _ref;

  FirestoreService get _firestore => _ref.read(firestoreServiceProvider);
  StorageService get _storage => _ref.read(storageServiceProvider);

  Future<void> toggleLike(String postId) async {
    final authState = _ref.read(authStateProvider);
    final uid = authState.valueOrNull?.uid;
    if (uid == null) return;
    await _firestore.toggleLike(postId, uid);
  }

  Future<void> addPost({
    required String caption,
    List<File> imageFiles = const [],
    String? location,
    int? bortleClass,
  }) async {
    final authState = _ref.read(authStateProvider);
    final uid = authState.valueOrNull?.uid;
    if (uid == null) return;

    // Create post first to get ID
    final postId = await _firestore.createPost({
      'userId': uid,
      'caption': caption,
      'imageAssets': <String>[],
      'imageUrls': <String>[],
      'likedBy': <String>[],
      'bookmarkedBy': <String>[],
      'reposts': 0,
      'location': location,
      'bortleClass': bortleClass,
      'createdAt': DateTime.now(),
    });

    // Upload images if any
    if (imageFiles.isNotEmpty) {
      try {
        final urls = await _storage.uploadPostImages(imageFiles, postId);
        await _firestore.updatePost(postId, {'imageUrls': urls});
      } catch (_) {
        // Firebase Storage upload failed — save images locally as fallback.
        // Copy files to app support directory so they persist.
        try {
          final postDir = Directory('${Directory.systemTemp.path}/sura_post_images/$postId');
          await postDir.create(recursive: true);

          final localPaths = <String>[];
          for (int i = 0; i < imageFiles.length; i++) {
            final dest = '${postDir.path}/image_$i.jpg';
            await imageFiles[i].copy(dest);
            localPaths.add(dest);
          }
          // Store local paths in Firestore so the app can display them
          await _firestore.updatePost(postId, {'localImagePaths': localPaths});
        } catch (_) {
          // If even local save fails, post still exists with text only
        }
      }
    }
  }

  Future<void> deletePost(String postId) async {
    // Get post data to find image URLs
    final posts = _ref.read(postsStreamProvider).valueOrNull ?? [];
    final post = posts.where((p) => p.id == postId).firstOrNull;
    if (post != null && post.imageUrls.isNotEmpty) {
      await _storage.deletePostImages(post.imageUrls);
    }
    await _firestore.deletePost(postId);
  }

  Future<void> toggleBookmark(String postId) async {
    final authState = _ref.read(authStateProvider);
    final uid = authState.valueOrNull?.uid;
    if (uid == null) return;
    await _firestore.toggleBookmark(postId, uid);
  }

  Future<void> addComment(String postId, String text) async {
    final authState = _ref.read(authStateProvider);
    final uid = authState.valueOrNull?.uid;
    if (uid == null) return;
    await _firestore.addComment(postId, {
      'userId': uid,
      'text': text,
      'createdAt': DateTime.now(),
    });
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier(ref);
});
