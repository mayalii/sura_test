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

  // ── Chat / Conversations ─────────────────────────────

  /// Stream all conversations the current user is part of.
  Stream<QuerySnapshot> conversationsStream(String uid) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }

  /// Stream messages in a conversation, ordered oldest-first.
  Stream<QuerySnapshot> messagesStream(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Create or get existing conversation between two users.
  Future<String> getOrCreateConversation(String uid1, String uid2) async {
    // Check if conversation already exists
    final existing = await _db
        .collection('conversations')
        .where('participants', arrayContains: uid1)
        .get();

    for (final doc in existing.docs) {
      final participants = List<String>.from(doc.data()['participants'] ?? []);
      if (participants.contains(uid2)) {
        return doc.id;
      }
    }

    // Create new conversation
    final ref = await _db.collection('conversations').add({
      'participants': [uid1, uid2],
      'lastMessageText': '',
      'lastMessageSenderId': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'unreadCount_$uid1': 0,
      'unreadCount_$uid2': 0,
    });
    return ref.id;
  }

  /// Send a message in a conversation.
  Future<void> sendMessage(String conversationId, String senderId, String text, String otherUid) async {
    final batch = _db.batch();

    // Add message to subcollection
    final msgRef = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();
    batch.set(msgRef, {
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Update conversation metadata
    final convRef = _db.collection('conversations').doc(conversationId);
    batch.update(convRef, {
      'lastMessageText': text,
      'lastMessageSenderId': senderId,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'unreadCount_$otherUid': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Mark all messages in a conversation as read for the given user.
  Future<void> markConversationRead(String conversationId, String uid) async {
    await _db.collection('conversations').doc(conversationId).update({
      'unreadCount_$uid': 0,
    });
  }
}
