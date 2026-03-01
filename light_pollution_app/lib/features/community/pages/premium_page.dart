import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';

class PremiumPage extends ConsumerStatefulWidget {
  const PremiumPage({super.key});

  @override
  ConsumerState<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends ConsumerState<PremiumPage> {
  bool _isApplying = false;

  Future<void> _applyForPremium() async {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isApplying = true);

    try {
      // Save the premium application to Firestore
      await FirebaseFirestore.instance
          .collection('premium_applications')
          .doc(user.id)
          .set({
        'userId': user.id,
        'userName': user.name,
        'username': user.username,
        'status': 'pending',
        'appliedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.premiumApplied),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.premiumApplicationFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final isPremium = currentUser?.isPremium ?? false;

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Premium icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              l10n.premiumTitle,
              style: font(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.premiumSubtitle,
              style: font(
                color: Colors.white60,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Premium member badge (if premium)
            if (isPremium) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withValues(alpha: 0.2),
                      const Color(0xFFFFA500).withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Color(0xFFFFD700), size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.premiumMemberSince,
                            style: font(
                              color: const Color(0xFFFFD700),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentUser?.name ?? '',
                            style: font(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.premiumYourBenefits,
                  style: font(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Feature cards
            _FeatureCard(
              icon: Icons.explore,
              title: l10n.premiumFeatureTrips,
              description: l10n.premiumFeatureTripsDesc,
              isUnlocked: isPremium,
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.workspace_premium,
              title: l10n.premiumFeatureBadge,
              description: l10n.premiumFeatureBadgeDesc,
              isUnlocked: isPremium,
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.bookmark_added,
              title: l10n.premiumFeaturePriority,
              description: l10n.premiumFeaturePriorityDesc,
              isUnlocked: isPremium,
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.auto_awesome,
              title: l10n.premiumFeatureAnalysis,
              description: l10n.premiumFeatureAnalysisDesc,
              isUnlocked: isPremium,
            ),

            // Criteria + Apply (if not premium)
            if (!isPremium) ...[
              const SizedBox(height: 32),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.premiumCriteriaTitle,
                  style: font(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _CriteriaItem(text: l10n.premiumCriteria1),
              const SizedBox(height: 10),
              _CriteriaItem(text: l10n.premiumCriteria2),
              const SizedBox(height: 10),
              _CriteriaItem(text: l10n.premiumCriteria3),
              const SizedBox(height: 32),

              // Apply button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isApplying ? null : _applyForPremium,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isApplying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.dark,
                          ),
                        )
                      : Text(
                          l10n.applyForPremium,
                          style: font(
                            color: AppColors.dark,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFFD700), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: font(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: font(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 22),
        ],
      ),
    );
  }
}

class _CriteriaItem extends StatelessWidget {
  const _CriteriaItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: font(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
