import 'package:flutter/material.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/chat_models.dart';
import '../models/mock_chats.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _searchController = TextEditingController();
  String _query = '';
  late List<Conversation> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = MockChats.getConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> get _filteredConversations {
    if (_query.isEmpty) return _conversations;
    final q = _query.toLowerCase();
    return _conversations.where((c) {
      return c.otherUser.name.toLowerCase().contains(q) ||
          c.otherUser.username.toLowerCase().contains(q) ||
          c.lastMessage.text.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final filtered = _filteredConversations;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Messages',
          style: font(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.navy, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'chatFab',
        onPressed: () {},
        backgroundColor: AppColors.navy,
        child: const Icon(Icons.mail_outline, color: AppColors.white),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: AppColors.textHint, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: font(fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search Direct Messages',
                        hintStyle: font(fontSize: 14, color: AppColors.textHint),
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
                        child: Icon(Icons.close, color: AppColors.textHint, size: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Conversations list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No messages found',
                          style: font(color: AppColors.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 76,
                      color: AppColors.divider,
                    ),
                    itemBuilder: (context, index) {
                      final conv = filtered[index];
                      return _ConversationTile(
                        conversation: conv,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => ChatDetailPage(conversation: conv),
                            ),
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

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final user = conversation.otherUser;
    final lastMsg = conversation.lastMessage;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
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
            // Content
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
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, color: AppColors.navy, size: 16),
                      ],
                      const SizedBox(width: 4),
                      Text(
                        user.username,
                        style: font(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        conversation.lastMessageTime,
                        style: font(
                          color: hasUnread ? AppColors.navy : AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg.text,
                          style: font(
                            color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
