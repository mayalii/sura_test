import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/community_models.dart';
import '../providers/community_provider.dart';
import '../widgets/sky_post_card.dart';
import '../widgets/comments_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import 'user_profile_page.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final postsAsync = ref.watch(postsStreamProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final uid = currentUser?.id ?? '';
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.accent),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          l10n.bookmarksTitle,
          style: font(
            color: c.accent,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: postsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: c.accent),
        ),
        error: (e, _) => Center(
          child: Text(
            l10n.failedToLoadPosts,
            style: font(color: c.textSecondary),
          ),
        ),
        data: (posts) {
          final bookmarked = posts.where((p) => p.bookmarkedBy.contains(uid)).toList();

          if (bookmarked.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: c.textHint),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noBookmarks,
                    style: font(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noBookmarksDesc,
                    style: font(color: c.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookmarked.length,
            itemBuilder: (context, index) {
              final post = bookmarked[index];
              return SkyPostCard(
                post: post,
                onLike: () => ref.read(communityProvider.notifier).toggleLike(post.id),
                onComment: () => _showComments(context, post),
                onDelete: post.userId == uid
                    ? () => ref.read(communityProvider.notifier).deletePost(post.id)
                    : null,
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
