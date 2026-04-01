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

/// Profile page for viewing another user's profile.
class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key, required this.user});

  final MockUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final c = context.colors;
    final postsAsync = ref.watch(postsStreamProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final isOwnProfile = currentUser?.id == user.id;

    // Get this user's posts (only if not private, or if it's own profile)
    final allPosts = postsAsync.valueOrNull ?? [];
    final userPosts = allPosts.where((p) => p.userId == user.id).toList();
    final canSeePosts = !user.isPrivate || isOwnProfile;

    return Scaffold(
      backgroundColor: c.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Banner
            SliverAppBar(
              pinned: false,
              expandedHeight: 244,
              backgroundColor: const Color(0xFF0a0a2e),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Banner background
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 44,
                      child: user.bannerUrl != null
                          ? Image.network(user.bannerUrl!,
                              fit: BoxFit.cover, width: double.infinity)
                          : Container(
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
                    ),
                    // Area below banner
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 44,
                      child: Container(color: c.background),
                    ),
                    // Avatar
                    Positioned(
                      left: 16,
                      bottom: 6,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                          border: Border.all(color: c.background, width: 3.5),
                        ),
                        child: user.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(user.avatarUrl!,
                                    fit: BoxFit.cover, width: 76, height: 76),
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
                    // Name + verified + private
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: font(
                              color: c.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified, color: c.accent, size: 20),
                        ],
                        if (user.isPrivate) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.lock, color: c.textSecondary, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Username
                    Text(
                      user.username,
                      style: font(color: c.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // Bio
                    if (user.bio.isNotEmpty)
                      Text(
                        user.bio,
                        style: font(
                          color: c.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Divider
                    Divider(height: 1, color: c.divider),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ];
        },
        body: canSeePosts
            ? _buildPostsList(context, ref, userPosts, l10n, font, c)
            : _buildPrivateMessage(font, c, l10n),
      ),
    );
  }

  Widget _buildPostsList(
    BuildContext context,
    WidgetRef ref,
    List<SkyPost> posts,
    AppLocalizations l10n,
    TextStyle Function({
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? height,
      double? letterSpacing,
      TextDecoration? decoration,
    }) font,
    AdaptiveColors c,
  ) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 48, color: c.textHint),
            const SizedBox(height: 12),
            Text(
              l10n.noPostsYetSimple,
              style: font(color: c.textSecondary, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return SkyPostCard(
          post: post,
          onLike: () => ref.read(communityProvider.notifier).toggleLike(post.id),
          onComment: () => _showComments(context, post),
        );
      },
    );
  }

  Widget _buildPrivateMessage(
    TextStyle Function({
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? height,
      double? letterSpacing,
      TextDecoration? decoration,
    }) font,
    AdaptiveColors c,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 56, color: c.textHint),
            const SizedBox(height: 16),
            Text(
              l10n.privateAccountTitle,
              style: font(
                color: c.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.privateAccountMessage,
              textAlign: TextAlign.center,
              style: font(color: c.textSecondary, fontSize: 14),
            ),
          ],
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
