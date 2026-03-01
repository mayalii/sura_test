import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/community_models.dart';
import '../providers/community_provider.dart';
import '../widgets/sky_post_card.dart';
import '../widgets/comments_sheet.dart';
import 'edit_profile_page.dart';
import 'compose_post_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
      ),
    );

    if (result != null && result['updated'] == true) {
      ref.invalidate(currentUserProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final postsAsync = ref.watch(postsStreamProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    final user = currentUserAsync.valueOrNull ??
        MockUser(
          id: '',
          name: l10n.loadingText,
          username: '@...',
          avatarInitials: '?',
          bio: '',
        );

    final posts = postsAsync.valueOrNull ?? [];
    final userPosts = posts.where((p) => p.userId == user.id).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const ComposePostPage()),
          );
        },
        backgroundColor: AppColors.navy,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Banner that extends through the entire top
            SliverAppBar(
              pinned: false,
              expandedHeight: 244,
              backgroundColor: const Color(0xFF0a0a2e),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.white, size: 22),
                  onPressed: _openEditProfile,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Banner background (top 200px)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 44,
                      child: user.bannerUrl != null
                          ? Image.network(user.bannerUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity)
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF0a0a2e),
                                        Color(0xFF1a1a4e),
                                        Color(0xFF0d0d1a),
                                      ],
                                    ),
                                  ),
                                ),
                                CustomPaint(painter: _BannerStarsPainter()),
                              ],
                            ),
                    ),
                    // White area below banner
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 44,
                      child: Container(color: AppColors.white),
                    ),
                    // Avatar overlapping banner and white area
                    Positioned(
                      left: 16,
                      bottom: 6,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                          border: Border.all(
                              color: AppColors.white, width: 3.5),
                        ),
                        child: user.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(user.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: 76,
                                    height: 76),
                              )
                            : Center(
                                child: Text(
                                  user.avatarInitials,
                                  style: font(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + verified
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: font(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.navy, size: 20),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Username
                    Text(
                      user.username,
                      style: font(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Bio
                    if (user.bio.isNotEmpty)
                      Text(
                        user.bio,
                        style: font(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.navy,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.navy,
                  indicatorWeight: 3,
                  labelStyle: font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: font(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: l10n.posts),
                    Tab(text: l10n.repliesTab),
                    Tab(text: l10n.photos),
                    Tab(text: l10n.likesTab),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Posts tab
            _buildPostsList(userPosts),
            // Replies tab (placeholder)
            _buildEmptyTab(l10n.noRepliesYet),
            // Photos tab (placeholder)
            _buildEmptyTab(l10n.noPhotosYet),
            // Likes tab (placeholder)
            _buildEmptyTab(l10n.noLikesYet),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(List<SkyPost> posts) {
    if (posts.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return _buildEmptyTab(l10n.noPostsYetSimple);
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return SkyPostCard(
          post: post,
          onLike: () =>
              ref.read(communityProvider.notifier).toggleLike(post.id),
          onComment: () => _showComments(context, post),
          onDelete: () => ref.read(communityProvider.notifier).deletePost(post.id),
        );
      },
    );
  }

  Widget _buildEmptyTab(String message) {
    final font = AppFonts.style(context);
    return Center(
      child: Text(
        message,
        style: font(
          color: AppColors.textSecondary,
          fontSize: 15,
        ),
      ),
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _BannerStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    var hash = 42;
    for (int i = 0; i < 80; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % size.width.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % size.height.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final brightness = 0.2 + (hash % 60) / 100.0;
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final radius = 0.4 + (hash % 15) / 15.0;
      paint.color = Colors.white.withValues(alpha: brightness);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    for (int i = 0; i < 5; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % size.width.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % size.height.toInt()).toDouble();
      paint.color = Colors.white.withValues(alpha: 0.85);
      canvas.drawCircle(Offset(x, y), 1.8, paint);
      paint.color = Colors.white.withValues(alpha: 0.12);
      canvas.drawCircle(Offset(x, y), 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
