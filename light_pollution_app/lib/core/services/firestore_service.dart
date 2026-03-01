import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/community/models/community_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────

  Future<MockUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return MockUser.fromMap(doc.id, doc.data()!);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // ── Posts ──────────────────────────────────────────────

  Stream<List<SkyPost>> postsStream() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final posts = <SkyPost>[];
      // Collect unique user IDs
      final userIds = snapshot.docs.map((d) => d.data()['userId'] as String).toSet();
      // Batch-fetch users
      final usersMap = <String, MockUser>{};
      for (final uid in userIds) {
        if (uid.isEmpty) continue;
        final user = await getUser(uid);
        if (user != null) usersMap[uid] = user;
      }

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String? ?? '';
        final user = usersMap[userId] ??
            MockUser(
              id: userId,
              name: 'Unknown',
              username: '@unknown',
              avatarInitials: '?',
              bio: '',
            );

        // Fetch comments for this post
        final commentsSnap = await _db
            .collection('posts')
            .doc(doc.id)
            .collection('comments')
            .orderBy('createdAt', descending: false)
            .get();

        final comments = <PostComment>[];
        for (final commentDoc in commentsSnap.docs) {
          final commentData = commentDoc.data();
          final commentUserId = commentData['userId'] as String? ?? '';
          MockUser commentUser;
          if (usersMap.containsKey(commentUserId)) {
            commentUser = usersMap[commentUserId]!;
          } else {
            commentUser = await getUser(commentUserId) ??
                MockUser(
                  id: commentUserId,
                  name: 'Unknown',
                  username: '@unknown',
                  avatarInitials: '?',
                  bio: '',
                );
            usersMap[commentUserId] = commentUser;
          }
          comments.add(PostComment.fromMap(commentDoc.id, commentData, commentUser));
        }

        posts.add(SkyPost.fromMap(doc.id, data, user, comments));
      }
      return posts;
    });
  }

  Future<String> createPost(Map<String, dynamic> data) async {
    final ref = await _db.collection('posts').add(data);
    return ref.id;
  }

  Future<void> deletePost(String postId) async {
    // Delete comments subcollection first
    final comments = await _db.collection('posts').doc(postId).collection('comments').get();
    for (final doc in comments.docs) {
      await doc.reference.delete();
    }
    await _db.collection('posts').doc(postId).delete();
  }

  Future<void> toggleLike(String postId, String userId) async {
    final ref = _db.collection('posts').doc(postId);
    final doc = await ref.get();
    if (!doc.exists) return;

    final likedBy = List<String>.from(doc.data()?['likedBy'] ?? []);
    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
    } else {
      likedBy.add(userId);
    }
    await ref.update({'likedBy': likedBy});
  }

  Future<void> toggleBookmark(String postId, String userId) async {
    final ref = _db.collection('posts').doc(postId);
    final doc = await ref.get();
    if (!doc.exists) return;

    final bookmarkedBy = List<String>.from(doc.data()?['bookmarkedBy'] ?? []);
    if (bookmarkedBy.contains(userId)) {
      bookmarkedBy.remove(userId);
    } else {
      bookmarkedBy.add(userId);
    }
    await ref.update({'bookmarkedBy': bookmarkedBy});
  }

  // ── Comments ──────────────────────────────────────────

  Future<void> addComment(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).collection('comments').add(data);
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).update(data);
  }
}
