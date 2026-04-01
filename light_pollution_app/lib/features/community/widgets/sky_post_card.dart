import 'dart:io';
import 'package:flutter/material.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../models/community_models.dart';

class SkyPostCard extends StatelessWidget {
  const SkyPostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    this.onDelete,
    this.onUserTap,
  });

  final SkyPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onDelete;
  final VoidCallback? onUserTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header - single line: Avatar | Name [verified] @username . 9h ... [menu]
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                GestureDetector(
                  onTap: onUserTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.navy,
                    ),
                    child: Center(
                      child: Text(
                        post.user.avatarInitials,
                        style: AppFonts.style(context)(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Content column (header + caption + images + actions)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Single-line header
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    post.user.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.style(context)(
                                      color: c.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (post.user.isVerified) ...[
                                  const SizedBox(width: 3),
                                  Icon(Icons.verified, color: c.accent, size: 16),
                                ],
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    post.user.username,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.style(context)(
                                      color: c.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            ' · ${post.timeAgo}',
                            style: AppFonts.style(context)(
                              color: c.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (onDelete != null)
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: c.surface,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  builder: (_) => SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        leading: const Icon(Icons.delete_outline, color: Colors.red),
                                        title: Text(
                                          AppLocalizations.of(context)!.deletePost,
                                          style: AppFonts.style(context)(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          onDelete!();
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.more_horiz, color: c.textSecondary, size: 18),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Caption
                      Text(
                        post.caption,
                        style: AppFonts.style(context)(
                          color: c.textPrimary,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),

                      // Images (network URLs, local files, or asset placeholders)
                      if (post.imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _NetworkImageSection(imageUrls: post.imageUrls),
                      ] else if (post.imageFiles.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _UserImageSection(imageFiles: post.imageFiles),
                      ] else if (post.imageAssets.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _PostImageSection(imageAssets: post.imageAssets),
                      ],

                      // Actions row
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ActionButton(
                              icon: Icons.chat_bubble_outline,
                              color: c.textSecondary,
                              label: formatCount(post.comments.length),
                              onTap: onComment,
                            ),
                            _ActionButton(
                              icon: Icons.repeat,
                              color: c.textSecondary,
                              label: formatCount(post.reposts),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.repost),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            _ActionButton(
                              icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: post.isLiked ? Colors.redAccent : c.textSecondary,
                              label: formatCount(post.likes),
                              onTap: onLike,
                            ),
                            GestureDetector(
                              onTap: () {
                                final text = '${post.user.name}: ${post.caption}';
                                Share.share(text);
                              },
                              child: Icon(
                                Icons.ios_share_outlined,
                                color: c.textSecondary,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _PostImageSection extends StatelessWidget {
  const _PostImageSection({required this.imageAssets});

  final List<String> imageAssets;

  @override
  Widget build(BuildContext context) {
    if (imageAssets.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: _SkyImagePlaceholder(imageAsset: imageAssets[0]),
        ),
      );
    }

    // 2 images side by side
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: _SkyImagePlaceholder(imageAsset: imageAssets[0]),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _SkyImagePlaceholder(imageAsset: imageAssets[1]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          if (label.isNotEmpty && label != '0') ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: AppFonts.style(context)(color: context.colors.textSecondary, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserImageSection extends StatelessWidget {
  const _UserImageSection({required this.imageFiles});

  final List<dynamic> imageFiles;

  @override
  Widget build(BuildContext context) {
    if (imageFiles.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.file(imageFiles[0] as File, fit: BoxFit.cover),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: Image.file(imageFiles[0] as File, fit: BoxFit.cover, height: 200),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Image.file(imageFiles[1] as File, fit: BoxFit.cover, height: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkImageSection extends StatelessWidget {
  const _NetworkImageSection({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            imageUrls[0],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: c.card,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: c.card,
                child: Center(child: Icon(Icons.broken_image, color: c.textHint)),
              );
            },
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: Image.network(imageUrls[0], fit: BoxFit.cover, height: 200),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Image.network(
                imageUrls.length > 1 ? imageUrls[1] : imageUrls[0],
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkyImagePlaceholder extends StatelessWidget {
  const _SkyImagePlaceholder({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsForAsset(imageAsset);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
        ),
        CustomPaint(painter: _StarsPainter(imageAsset.hashCode)),
      ],
    );
  }

  List<Color> _getColorsForAsset(String asset) {
    switch (asset) {
      case 'milky_way':
        return [const Color(0xFF0a0a2e), const Color(0xFF1a1a4e), const Color(0xFF0d0d1a)];
      case 'desert_stars':
        return [const Color(0xFF000814), const Color(0xFF001d3d), const Color(0xFF1a0a00)];
      case 'orion_nebula':
        return [const Color(0xFF0a0020), const Color(0xFF2d1b69), const Color(0xFF0a0a2e)];
      case 'moon_city':
        return [const Color(0xFF1a1a2e), const Color(0xFF2a2a4e), const Color(0xFF3a3a3a)];
      case 'comparison':
        return [const Color(0xFF0a0a1e), const Color(0xFF1e1e3e), const Color(0xFF2e2e2e)];
      case 'milky_sea':
        return [const Color(0xFF000814), const Color(0xFF003566), const Color(0xFF001d3d)];
      case 'alula_sky':
        return [const Color(0xFF000000), const Color(0xFF0d1b2a), const Color(0xFF0a0a0a)];
      case 'beginner_sky':
        return [const Color(0xFF0f0f2e), const Color(0xFF1e1e4e), const Color(0xFF15152e)];
      default:
        return [const Color(0xFF0a0a2e), const Color(0xFF1a1a3e), const Color(0xFF0d0d1a)];
    }
  }
}

class _StarsPainter extends CustomPainter {
  _StarsPainter(this.seed);
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    var hash = seed;
    for (int i = 0; i < 50; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % size.width.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % size.height.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final brightness = 0.3 + (hash % 70) / 100.0;
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final radius = 0.5 + (hash % 20) / 15.0;
      paint.color = Colors.white.withValues(alpha: brightness);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    for (int i = 0; i < 4; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % size.width.toInt()).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % (size.height * 0.6).toInt()).toDouble();
      paint.color = Colors.white.withValues(alpha: 0.9);
      canvas.drawCircle(Offset(x, y), 2.0, paint);
      paint.color = Colors.white.withValues(alpha: 0.15);
      canvas.drawCircle(Offset(x, y), 5.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
