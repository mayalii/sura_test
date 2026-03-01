import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  File? _bannerImage;
  bool _isSaving = false;

  String? _existingAvatarUrl;
  String? _existingBannerUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _websiteController = TextEditingController();

    // Load current user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null) {
        _nameController.text = user.name;
        _bioController.text = user.bio;
        _existingAvatarUrl = user.avatarUrl;
        _existingBannerUrl = user.bannerUrl;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    _showImageSourceSheet((source) async {
      final picked = await _picker.pickImage(source: source, maxWidth: 800);
      if (picked != null) {
        setState(() => _profileImage = File(picked.path));
      }
    });
  }

  Future<void> _pickBannerImage() async {
    _showImageSourceSheet((source) async {
      final picked = await _picker.pickImage(source: source, maxWidth: 1600);
      if (picked != null) {
        setState(() => _bannerImage = File(picked.path));
      }
    });
  }

  void _showImageSourceSheet(Future<void> Function(ImageSource) onPick) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.white),
              title: Text(l10n.takeAPhoto,
                  style: font(color: AppColors.white, fontSize: 16)),
              onTap: () {
                Navigator.pop(ctx);
                onPick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.white),
              title: Text(l10n.chooseFromGallery,
                  style: font(color: AppColors.white, fontSize: 16)),
              onTap: () {
                Navigator.pop(ctx);
                onPick(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      final firestore = ref.read(firestoreServiceProvider);
      final updates = <String, dynamic>{
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      // Update initials
      final name = _nameController.text.trim();
      if (name.isNotEmpty) {
        final initials = name.split(' ').map((w) => w[0]).take(2).join().toUpperCase();
        updates['avatarInitials'] = initials;
      }

      await firestore.updateUser(uid, updates);
      if (mounted) {
        Navigator.of(context).pop({'updated': true});
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToSave(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: font(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
        title: Text(
          l10n.editProfile,
          style: font(
            color: AppColors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    l10n.save,
                    style: font(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image area
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner - tappable to change
                GestureDetector(
                  onTap: _pickBannerImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0a0a2e),
                          Color(0xFF1a1a4e),
                          Color(0xFF0d0d1a),
                        ],
                      ),
                    ),
                    child: _bannerImage != null
                        ? Image.file(_bannerImage!, fit: BoxFit.cover)
                        : _existingBannerUrl != null
                            ? Image.network(_existingBannerUrl!, fit: BoxFit.cover)
                            : Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  size: 32,
                                ),
                              ),
                  ),
                ),

                // Profile avatar overlapping banner - tappable to change
                Positioned(
                  left: 16,
                  bottom: -36,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.navy,
                            border:
                                Border.all(color: AppColors.dark, width: 3),
                          ),
                          child: _profileImage != null
                              ? ClipOval(
                                  child: Image.file(_profileImage!,
                                      fit: BoxFit.cover,
                                      width: 72,
                                      height: 72),
                                )
                              : _existingAvatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(_existingAvatarUrl!,
                                          fit: BoxFit.cover,
                                          width: 72,
                                          height: 72),
                                    )
                                  : Center(
                                      child: Text(
                                        ref.watch(currentUserProvider).valueOrNull?.avatarInitials ?? '?',
                                        style: font(
                                          color: AppColors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Form fields
            _EditField(
              label: l10n.nameLabel,
              controller: _nameController,
            ),
            const _FieldDivider(),
            _EditField(
              label: l10n.bioLabel,
              controller: _bioController,
              maxLines: 3,
            ),
            const _FieldDivider(),
            const SizedBox(height: 16),
            _EditField(
              label: l10n.locationLabel,
              controller: _locationController,
              trailing: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary, size: 22),
            ),
            const _FieldDivider(),
            _EditField(
              label: l10n.websiteLabel,
              controller: _websiteController,
              hint: l10n.addWebsite,
            ),
            const _FieldDivider(),
            // Birth date row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      l10n.birthDate,
                      style: font(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.addBirthDate,
                      style: font(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary, size: 22),
                ],
              ),
            ),
            const _FieldDivider(),

            const SizedBox(height: 8),

            // Switch to Professional
            _TapRow(
              label: l10n.switchToProfessional,
              onTap: () {},
            ),
            const _FieldDivider(),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 10 : 0),
            child: SizedBox(
              width: 90,
              child: Text(
                label,
                style: font(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: font(
                color: AppColors.white,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint ?? '',
                hintStyle: font(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.white12,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}

class _TapRow extends StatelessWidget {
  const _TapRow({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: font(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }
}
