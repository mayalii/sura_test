import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../community/models/community_models.dart';
import '../../community/models/mock_data.dart';
import '../models/chat_models.dart';
import '../providers/chat_provider.dart';
import 'chat_detail_page.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> _filterConversations(List<Conversation> conversations) {
    if (_query.isEmpty) return conversations;
    final q = _query.toLowerCase();
    return conversations.where((c) {
      return c.otherUser.name.toLowerCase().contains(q) ||
          c.otherUser.username.toLowerCase().contains(q) ||
          (c.messages.isNotEmpty && c.lastMessage.text.toLowerCase().contains(q));
    }).toList();
  }

  void _showNewMessageSheet(BuildContext context) {
    final uid = ref.read(authStateProvider).valueOrNull?.uid ?? '';
    final firestore = ref.read(firestoreServiceProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => _NewMessageSheet(
          scrollController: scrollController,
          onUserSelected: (user) async {
            Navigator.pop(ctx);
            // Create or get conversation in Firestore
            final convId = await firestore.getOrCreateConversation(uid, user.id);
            if (!mounted) return;
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => ChatDetailPage(
                  conversationId: convId,
                  otherUser: user,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final c = context.colors;
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Messages',
          style: font(
            color: c.accent,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: c.accent, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat settings coming soon')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'chatFab',
        onPressed: () => _showNewMessageSheet(context),
        backgroundColor: AppColors.navy,
        shape: const CircleBorder(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.chat_bubble, color: AppColors.white, size: 26),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.navy, size: 12),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.divider),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: c.textHint, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: font(fontSize: 14, color: c.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search Direct Messages',
                        hintStyle: font(fontSize: 14, color: c.textHint),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.close, color: c.textHint, size: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Divider(height: 1, color: c.divider),

          // Conversations list
          Expanded(
            child: conversationsAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: c.accent),
              ),
              error: (_, __) => Center(
                child: Text('Failed to load messages', style: font(color: c.textSecondary)),
              ),
              data: (conversations) {
                final filtered = _filterConversations(conversations);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: c.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No messages found',
                          style: font(color: c.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 76,
                    color: c.divider,
                  ),
                  itemBuilder: (context, index) {
                    final conv = filtered[index];
                    return _ConversationTile(
                      conversation: conv,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => ChatDetailPage(
                              conversationId: conv.id,
                              otherUser: conv.otherUser,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── New Message Sheet with search ──

class _NewMessageSheet extends StatefulWidget {
  const _NewMessageSheet({
    required this.scrollController,
    required this.onUserSelected,
  });

  final ScrollController scrollController;
  final void Function(MockUser user) onUserSelected;

  @override
  State<_NewMessageSheet> createState() => _NewMessageSheetState();
}

class _NewMessageSheetState extends State<_NewMessageSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MockUser> get _filteredUsers {
    if (_query.isEmpty) return MockData.allUsers;
    final q = _query.toLowerCase();
    return MockData.allUsers.where((user) {
      return user.name.toLowerCase().contains(q) ||
          user.username.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final users = _filteredUsers;
    final c = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: c.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'New Message',
                  style: font(
                    color: c.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: c.textSecondary, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.divider),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: c.textHint, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: font(fontSize: 14, color: c.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search people...',
                        hintStyle: font(fontSize: 14, color: c.textHint),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.close, color: c.textHint, size: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: c.divider),
          // User list
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      'No users found',
                      style: font(color: c.textSecondary, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    controller: widget.scrollController,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.navy,
                          child: Text(
                            user.avatarInitials,
                            style: font(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: font(
                                  color: c.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (user.isVerified) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.verified, color: c.accent, size: 16),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          user.username,
                          style: font(color: c.textSecondary, fontSize: 13),
                        ),
                        onTap: () => widget.onUserSelected(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Conversation Tile ──

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final user = conversation.otherUser;
    final hasUnread = conversation.unreadCount > 0;
    final hasMessages = conversation.messages.isNotEmpty;
    final lastMsg = hasMessages ? conversation.lastMessage : null;
    final c = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.navy,
              child: Text(
                user.avatarInitials,
                style: font(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          style: font(
                            color: c.textPrimary,
                            fontSize: 15,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, color: c.accent, size: 16),
                      ],
                      const SizedBox(width: 4),
                      Text(
                        user.username,
                        style: font(color: c.textSecondary, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        conversation.lastMessageTime,
                        style: font(
                          color: hasUnread ? c.accent : c.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (lastMsg != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMsg.text,
                            style: font(
                              color: hasUnread ? c.textPrimary : c.textSecondary,
                              fontSize: 14,
                              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.navy,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${conversation.unreadCount}',
                                style: font(
                                  color: AppColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
