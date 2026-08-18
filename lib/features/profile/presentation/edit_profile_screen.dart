import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _saving = false;
  String? _avatarPath;
  final _nameCtrl = TextEditingController(text: 'Yacine Belkacem');
  final _usernameCtrl = TextEditingController(text: 'yacine.b');
  final _bioCtrl = TextEditingController(
      text: 'Food explorer based in Alger. Always on the hunt for the best couscous.');
  String _selectedWilaya = 'Alger';

  static const _wilayas = [
    'Alger', 'Oran', 'Constantine', 'Annaba', 'Blida',
    'Sétif', 'Tlemcen', 'Béjaïa', 'Tizi Ouzou', 'Batna',
    'Sidi Bel Abbès', 'Biskra',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 90, maxWidth: 512);
    if (file != null && mounted) {
      setState(() => _avatarPath = file.path);
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }

  void _showWilayaPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.s12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSizes.s16),
              const Text('Select Wilaya',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900)),
              const SizedBox(height: AppSizes.s8),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: _wilayas.length,
                  itemBuilder: (context, i) {
                    final wilaya = _wilayas[i];
                    final selected = wilaya == _selectedWilaya;
                    return ListTile(
                      title: Text(wilaya,
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppColors.primary
                                : AppColors.neutral900,
                          )),
                      trailing: selected
                          ? const Icon(Icons.check_circle,
                              color: AppColors.primary,
                              size: AppSizes.iconInline)
                          : null,
                      onTap: () {
                        setState(() => _selectedWilaya = wilaya);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppColors.neutral900,
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit profile',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              'Save',
              style: TextStyle(
                color: _saving ? AppColors.neutral300 : AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar section
            Container(
              color: AppColors.neutral0,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.s24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.neutral200, width: 2),
                          ),
                          child: ClipOval(
                            child: _avatarPath != null
                                ? Image.file(File(_avatarPath!),
                                    fit: BoxFit.cover)
                                : Container(
                                    color: AppColors.primary,
                                    child: const Center(
                                      child: Text('A',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s10),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: const Text(
                      'Change photo',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal),

            const SizedBox(height: AppSizes.s12),

            // Fields
            Container(
              color: AppColors.neutral0,
              padding: const EdgeInsets.all(AppSizes.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Display name'),
                  const SizedBox(height: AppSizes.s8),
                  _Field(controller: _nameCtrl, hint: 'Your name'),
                  const SizedBox(height: AppSizes.s20),
                  _FieldLabel('Username'),
                  const SizedBox(height: AppSizes.s8),
                  _Field(
                    controller: _usernameCtrl,
                    hint: 'username',
                    prefix: '@',
                  ),
                  const SizedBox(height: AppSizes.s20),
                  _FieldLabel('Bio'),
                  const SizedBox(height: AppSizes.s8),
                  TextField(
                    controller: _bioCtrl,
                    maxLines: 3,
                    maxLength: 160,
                    decoration: InputDecoration(
                      hintText: 'Tell others about your taste…',
                      hintStyle: const TextStyle(color: AppColors.neutral300),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      counterStyle: const TextStyle(
                          fontSize: 11, color: AppColors.neutral300),
                      contentPadding: const EdgeInsets.all(AppSizes.s12),
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: 80.ms)
                .fadeIn(duration: AppAnimations.normal)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppSizes.s12),

            // Wilaya
            GestureDetector(
              onTap: _showWilayaPicker,
              child: Container(
                color: AppColors.neutral0,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s20, vertical: AppSizes.s16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: AppSizes.iconInline, color: AppColors.neutral500),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Wilaya',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.neutral500)),
                          const SizedBox(height: 2),
                          Text(_selectedWilaya,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.neutral900,
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.neutral300, size: AppSizes.iconInline),
                  ],
                ),
              ),
            )
                .animate(delay: 160.ms)
                .fadeIn(duration: AppAnimations.normal),

            const SizedBox(height: AppSizes.s32),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              child: PrimaryButton(
                label: 'Save changes',
                loading: _saving,
                onTap: _save,
              ),
            )
                .animate(delay: 240.ms)
                .fadeIn(duration: AppAnimations.normal)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppSizes.s48),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral700));
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint, this.prefix});
  final TextEditingController controller;
  final String hint;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.neutral300),
        prefixText: prefix,
        prefixStyle: const TextStyle(
            color: AppColors.neutral500, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s12, vertical: AppSizes.s12),
      ),
    );
  }
}
