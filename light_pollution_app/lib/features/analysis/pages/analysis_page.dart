import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import 'package:light_pollution_app/core/l10n/bortle_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/analysis_provider.dart';
import '../widgets/analysis_result_card.dart';
import '../widgets/brightness_histogram.dart';

// Dark colors for the detection/camera page
class _DetectColors {
  static const background = AppColors.dark;
  static const surface = Color(0xFF1A2633);
  static const accent = Color(0xFF4D759E);
  static const textMuted = Color(0xFF8899AA);
  static const textLight = Color(0xFFCCDDEE);
}

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  bool get _isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);

    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: _DetectColors.background,
        body: SafeArea(
          child: switch (state.status) {
            AnalysisStatus.idle => _buildIdleState(context, ref),
            AnalysisStatus.analyzing => _buildAnalyzingState(context, state),
            AnalysisStatus.done => _buildResultsState(context, ref, state),
            AnalysisStatus.error => _buildErrorState(context, ref, state),
          },
        ),
      ),
    );
  }

  Widget _buildIdleState(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);

    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.expand_less, color: _DetectColors.textMuted, size: 28),
            ],
          ),
        ),

        // Main viewfinder area
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _DetectColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo_white.png',
                    height: 160,
                    opacity: const AlwaysStoppedAnimation(0.85),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.pollutionDetection,
                    style: font(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.takeOrUploadPhoto,
                    textAlign: TextAlign.center,
                    style: font(
                      color: _DetectColors.textLight.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Bottom controls - camera style
        Padding(
          padding: const EdgeInsets.only(bottom: 32, left: 40, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gallery button
              GestureDetector(
                onTap: () => ref.read(analysisProvider.notifier).pickFromGallery(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _DetectColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _DetectColors.textMuted, width: 1),
                  ),
                  child: Icon(Icons.photo_library, color: _DetectColors.textLight, size: 22),
                ),
              ),

              // Big PHOTO capture button
              GestureDetector(
                onTap: _isDesktop
                    ? () => ref.read(analysisProvider.notifier).pickFromGallery()
                    : () => ref.read(analysisProvider.notifier).takePhoto(),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.photoButton,
                      style: font(
                        color: _DetectColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Placeholder for symmetry
              const SizedBox(width: 48, height: 48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzingState(BuildContext context, AnalysisState state) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);

    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.expand_less, color: _DetectColors.textMuted, size: 28),
            ],
          ),
        ),

        // Image preview
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _DetectColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (state.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(state.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.dark.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: _DetectColors.accent),
                        const SizedBox(height: 16),
                        Text(
                          l10n.analyzing,
                          style: font(color: AppColors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResultsState(BuildContext context, WidgetRef ref, AnalysisState state) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final result = state.result!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Top bar with close
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => ref.read(analysisProvider.notifier).reset(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _DetectColors.surface,
                  ),
                  child: const Icon(Icons.close, color: AppColors.white, size: 20),
                ),
              ),
              const Spacer(),
              Icon(Icons.expand_less, color: _DetectColors.textMuted, size: 28),
              const Spacer(),
              const SizedBox(width: 36),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                // Image + Result overlay
                SizedBox(
                  height: screenHeight * 0.5,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _DetectColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (state.imagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(state.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        // Gradient overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.dark.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        // Result overlay
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  l10n.skyQualityLabel,
                                  style: font(
                                    color: _DetectColors.textLight.withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${result.pollutionLevel}%',
                                  style: font(
                                    color: AppColors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  result.localizedQualityLabel(l10n),
                                  style: font(
                                    color: result.pollutionColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Stargazing verdict
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: result.isGoodForStargazing
                                        ? const Color(0xFF1B5E20).withValues(alpha: 0.6)
                                        : const Color(0xFFB71C1C).withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: result.isGoodForStargazing
                                          ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                                          : const Color(0xFFF44336).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        result.isGoodForStargazing ? Icons.star : Icons.star_border,
                                        color: result.isGoodForStargazing
                                            ? const Color(0xFFFFD54F)
                                            : const Color(0xFFEF9A9A),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          result.localizedStargazingVerdict(l10n),
                                          style: font(
                                            color: AppColors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Pollution bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 6,
                                    child: LinearProgressIndicator(
                                      value: result.pollutionLevel / 100,
                                      backgroundColor: AppColors.white.withValues(alpha: 0.15),
                                      valueColor: AlwaysStoppedAnimation<Color>(result.pollutionColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('0', style: font(color: _DetectColors.textMuted, fontSize: 11)),
                                    Text('100', style: font(color: _DetectColors.textMuted, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Re-examine button
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () => ref.read(analysisProvider.notifier).reset(),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.navy,
                                    ),
                                    child: Text(
                                      l10n.reExamine,
                                      style: font(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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

                // Bottom detail section
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AnalysisResultCard(result: result),
                      const SizedBox(height: 8),
                      BrightnessHistogram(histogram: result.metrics.brightnessHistogram),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, WidgetRef ref, AnalysisState state) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);

    return Column(
      children: [
        // Top bar with close
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => ref.read(analysisProvider.notifier).reset(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _DetectColors.surface,
                  ),
                  child: const Icon(Icons.close, color: AppColors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    l10n.analysisFailed,
                    style: font(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? l10n.unknownError,
                    textAlign: TextAlign.center,
                    style: font(
                      color: _DetectColors.textLight.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => ref.read(analysisProvider.notifier).reset(),
                    child: Text(
                      l10n.reExamine,
                      style: font(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
