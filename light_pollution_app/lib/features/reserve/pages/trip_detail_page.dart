import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/trip_model.dart';
import '../providers/reserve_provider.dart';

class TripDetailPage extends ConsumerWidget {
  const TripDetailPage({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final tripsAsync = ref.watch(tripsStreamProvider);
    final trips = tripsAsync.valueOrNull ?? [];
    if (trips.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final trip = trips.firstWhere((t) => t.id == tripId, orElse: () => trips.first);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dateFormat = DateFormat('EEEE, MMM d, yyyy', isArabic ? 'ar' : 'en');

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header image
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: AppColors.navy,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (trip.coverImageUrl != null && trip.coverImageUrl!.isNotEmpty)
                          Image.network(
                            trip.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: trip.gradientColors,
                                ),
                              ),
                            ),
                          )
                        else ...[
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: trip.gradientColors,
                              ),
                            ),
                          ),
                          CustomPaint(painter: _StarsPainter(trip.id.hashCode)),
                        ],
                        // Bottom gradient overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.4),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Bortle badge
                        Positioned(
                          top: 100,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Bortle ${trip.bortleClass}',
                                  style: font(
                                    color: AppColors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Body
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          trip.title,
                          style: font(
                            color: AppColors.navy,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Location
                        _InfoRow(
                          icon: Icons.location_on,
                          text: trip.location,
                          font: font,
                        ),
                        const SizedBox(height: 8),
                        // Date
                        _InfoRow(
                          icon: Icons.calendar_today,
                          text: dateFormat.format(trip.date),
                          font: font,
                        ),
                        const SizedBox(height: 8),
                        // Duration
                        _InfoRow(
                          icon: Icons.schedule,
                          text: l10n.durationHours(trip.durationHours),
                          font: font,
                        ),
                        const SizedBox(height: 20),
                        // Guide info
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.navy,
                                ),
                                child: Center(
                                  child: Text(
                                    trip.guideName[0],
                                    style: font(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.guidedBy,
                                      style: font(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      trip.guideName,
                                      style: font(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.star, size: 16, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(
                                trip.guideRating.toString(),
                                style: font(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // About this trip
                        Text(
                          l10n.aboutTrip,
                          style: font(
                            color: AppColors.navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trip.description,
                          style: font(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // What's included
                        Text(
                          l10n.whatsIncluded,
                          style: font(
                            color: AppColors.navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...trip.included.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      size: 18, color: AppColors.navy),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: font(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),
                        // Stats row
                        Row(
                          children: [
                            _StatChip(
                              icon: Icons.star,
                              label: l10n.bortleClassLabel,
                              value: trip.bortleClass.toString(),
                              font: font,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              icon: Icons.group,
                              label: l10n.groupSize,
                              value: trip.maxGroupSize.toString(),
                              font: font,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              icon: Icons.event_seat,
                              label: l10n.spotsLeftLabel,
                              value: trip.spotsLeft.toString(),
                              font: font,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom booking bar
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${trip.price.toInt()} ',
                          style: font(
                            color: AppColors.navy,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/sar_symbol.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.navy,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      l10n.perPerson,
                      style: font(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: trip.isBooked
                          ? null
                          : () => _showBookingConfirmation(context, ref, trip, l10n, font),
                      style: FilledButton.styleFrom(
                        backgroundColor: trip.isBooked ? Colors.green : AppColors.navy,
                        disabledBackgroundColor: Colors.green,
                        disabledForegroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        trip.isBooked
                            ? l10n.tripBooked
                            : l10n.bookNow,
                        style: font(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(
    BuildContext context,
    WidgetRef ref,
    StargazingTrip trip,
    AppLocalizations l10n,
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    }) font,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.confirmation_num, size: 48, color: AppColors.navy),
              const SizedBox(height: 16),
              Text(
                l10n.bookNow,
                style: font(
                  color: AppColors.navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                trip.title,
                textAlign: TextAlign.center,
                style: font(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${trip.price.toInt()} ',
                    style: font(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/sar_symbol.svg',
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    ' ${l10n.perPerson}',
                    style: font(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () async {
                    final currentUser = ref.read(currentUserProvider).valueOrNull;
                    if (currentUser == null) return;
                    await bookTripInFirestore(trip.id, currentUser.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.tripBookedMsg),
                          backgroundColor: AppColors.navy,
                        ),
                      );
                    }
                  },
                  child: Text(
                    l10n.bookNow,
                    style: font(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancel,
                  style: font(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.font,
  });

  final IconData icon;
  final String text;
  final TextStyle Function({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) font;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: font(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.font,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle Function({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) font;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.navy),
            const SizedBox(height: 4),
            Text(
              value,
              style: font(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: font(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  _StarsPainter(this.seed);
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    var hash = seed;
    for (int i = 0; i < 60; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % max(1, size.width.toInt())).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % max(1, size.height.toInt())).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final brightness = 0.3 + (hash % 70) / 100.0;
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final radius = 0.5 + (hash % 20) / 15.0;
      paint.color = Colors.white.withValues(alpha: brightness);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    for (int i = 0; i < 6; i++) {
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final x = (hash % max(1, size.width.toInt())).toDouble();
      hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
      final y = (hash % max(1, (size.height * 0.7).toInt())).toDouble();
      paint.color = Colors.white.withValues(alpha: 0.9);
      canvas.drawCircle(Offset(x, y), 2.0, paint);
      paint.color = Colors.white.withValues(alpha: 0.15);
      canvas.drawCircle(Offset(x, y), 6.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
