import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../community/models/community_models.dart';
import '../models/chat_models.dart';
import '../models/mock_chats.dart';

/// Streams all conversations for the current user from Firestore,
/// with a fallback to mock data if Firestore is unavailable.
final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value([]);

  final firestore = ref.watch(firestoreServiceProvider);
  final controller = StreamController<List<Conversation>>();
  bool hasReceivedData = false;

  final sub = firestore.conversationsStream(uid).listen(
    (snapshot) async {
      hasReceivedData = true;
      final conversations = <Conversation>[];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final participants = List<String>.from(data['participants'] ?? []);
        final otherUid = participants.firstWhere((p) => p != uid, orElse: () => '');
        if (otherUid.isEmpty) continue;

        // Fetch the other user's profile
        final otherUser = await firestore.getUser(otherUid) ??
            MockUser(
              id: otherUid,
              name: 'Unknown',
              username: '@unknown',
              avatarInitials: '?',
              bio: '',
            );

        final unreadCount = (data['unreadCount_$uid'] as num?)?.toInt() ?? 0;
        final lastText = data['lastMessageText'] as String? ?? '';
        final lastSenderId = data['lastMessageSenderId'] as String? ?? '';
        final lastTimestamp = data['lastMessageTimestamp'];
        DateTime? lastTime;
        if (lastTimestamp is Timestamp) {
          lastTime = lastTimestamp.toDate();
        }

        conversations.add(Conversation(
          id: doc.id,
          otherUser: otherUser,
          unreadCount: unreadCount,
          messages: lastText.isNotEmpty
              ? [
                  ChatMessage(
                    id: 'last',
                    text: lastText,
                    senderId: lastSenderId,
                    timestamp: lastTime ?? DateTime.now(),
                    isRead: unreadCount == 0,
                  ),
                ]
              : [],
        ));
      }

      controller.add(conversations);
    },
    onError: (e) {
      debugPrint('Conversations stream error: $e');
      if (!hasReceivedData) {
        controller.add(MockChats.getConversations());
      }
    },
  );

  // Fallback to mock data after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (!controller.isClosed && !hasReceivedData) {
      controller.add(MockChats.getConversations());
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Streams messages for a specific conversation from Firestore.
final messagesProvider =
    StreamProvider.family<List<ChatMessage>, String>((ref, conversationId) {
  final firestore = ref.watch(firestoreServiceProvider);
  final controller = StreamController<List<ChatMessage>>();

  final sub = firestore.messagesStream(conversationId).listen(
    (snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'];
        DateTime time = DateTime.now();
        if (timestamp is Timestamp) {
          time = timestamp.toDate();
        }
        return ChatMessage(
          id: doc.id,
          text: data['text'] ?? '',
          senderId: data['senderId'] ?? '',
          timestamp: time,
          isRead: data['isRead'] ?? false,
        );
      }).toList();
      controller.add(messages);
    },
    onError: (e) {
      debugPrint('Messages stream error: $e');
      controller.add([]);
    },
  );

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
