import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../community/models/community_models.dart';
import '../../community/models/mock_data.dart';
import '../../community/providers/community_provider.dart';
import '../../community/widgets/sky_post_card.dart';
import '../../community/widgets/comments_sheet.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<MockUser> _searchUsers(String query) {
    if (query.isEmpty) return MockData.allUsers;
    final q = query.toLowerCase();
    return MockData.allUsers.where((user) {
      return user.name.toLowerCase().contains(q) ||
          user.username.toLowerCase().contains(q) ||
          user.bio.toLowerCase().contains(q);
    }).toList();
  }

  List<SkyPost> _searchPosts(String query, List<SkyPost> allPosts) {
    if (query.isEmpty) return allPosts;
    final q = query.toLowerCase();
    return allPosts.where((post) {
      return post.caption.toLowerCase().contains(q) ||
          post.user.name.toLowerCase().contains(q) ||
          post.user.username.toLowerCase().contains(q) ||
          (post.location?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final postsAsync = ref.watch(postsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar (X-style)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: AppColors.textHint, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        style: font(fontSize: 15, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search users, posts, locations...',
                          hintStyle: font(
                            fontSize: 15,
                            color: AppColors.textHint,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                          child: Icon(Icons.close, color: AppColors.textHint, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: AppColors.navy,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.navy,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: font(fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle: font(fontSize: 14, fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: 'People'),
                Tab(text: 'Posts'),
              ],
            ),

            const Divider(height: 1, color: AppColors.divider),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // People tab
                  _buildPeopleTab(font),

                  // Posts tab
                  _buildPostsTab(postsAsync, font),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleTab(TextStyle Function({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) font) {
    final users = _searchUsers(_query);

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'No users found',
              style: font(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserTile(user, font);
      },
    );
  }

  Widget _buildUserTile(MockUser user, TextStyle Function({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) font) {
    return InkWell(
      onTap: () {
        // Could navigate to user profile in the future
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            // Name & username & bio
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
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, color: AppColors.navy, size: 16),
                      ],
                      if (user.isPremium) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.username,
                    style: font(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.bio,
                    style: font(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab(AsyncValue<List<SkyPost>> postsAsync, TextStyle Function({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) font) {
    return postsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.navy),
      ),
      error: (e, _) => Center(
        child: Text(
          'Failed to load posts',
          style: font(color: AppColors.textSecondary),
        ),
      ),
      data: (posts) {
        final filtered = _searchPosts(_query, posts);
        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 48, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text(
                  'No posts found',
                  style: font(color: AppColors.textSecondary, fontSize: 16),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final post = filtered[index];
            return SkyPostCard(
              post: post,
              onLike: () => ref.read(communityProvider.notifier).toggleLike(post.id),
              onComment: () => _showComments(context, post),
              onDelete: () => ref.read(communityProvider.notifier).deletePost(post.id),
            );
          },
        );
      },
    );
  }

  void _showComments(BuildContext context, SkyPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => CommentsSheet(post: post),
      ),
    );
  }
}
