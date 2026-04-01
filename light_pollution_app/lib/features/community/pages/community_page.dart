import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/pages/home_page.dart';
import '../providers/community_provider.dart';
import '../widgets/sky_post_card.dart';
import '../widgets/comments_sheet.dart';
import 'compose_post_page.dart';
import 'user_profile_page.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(postsStreamProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final homeScaffoldKey = ref.watch(homeScaffoldKeyProvider);
    final font = AppFonts.style(context);

    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => homeScaffoldKey.currentState?.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(
              child: currentUser?.avatarUrl != null && currentUser!.avatarUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(currentUser.avatarUrl!),
                      backgroundColor: AppColors.navy,
                    )
                  : Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.navy,
                      ),
                      child: Center(
                        child: Text(
                          currentUser?.avatarInitials ?? '',
                          style: font(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        title: SvgPicture.asset(
          'assets/logo.svg',
          height: 36,
          colorFilter: ColorFilter.mode(c.accent, BlendMode.srcIn),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/map'),
            icon: Icon(Icons.explore_outlined, color: c.accent),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const ComposePostPage()),
          );
        },
        backgroundColor: c.accent,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: postsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: c.accent)),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '${l10n.failedToLoadPosts}\n$e',
              textAlign: TextAlign.center,
              style: AppFonts.style(context)(color: c.textSecondary),
            ),
          ),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Text(
                l10n.noPostsYet,
                style: AppFonts.style(context)(color: c.textSecondary),
              ),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return SkyPostCard(
                post: post,
                onLike: () => ref.read(communityProvider.notifier).toggleLike(post.id),
                onComment: () => _showComments(context, ref, post),
                onDelete: () => ref.read(communityProvider.notifier).deletePost(post.id),
                onUserTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => UserProfilePage(user: post.user)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showComments(BuildContext context, WidgetRef ref, post) {
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
