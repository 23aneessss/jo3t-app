import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/photo_picker.dart';
import '../../../shared/widgets/primary_button.dart';

class ManageVenueScreen extends StatefulWidget {
  const ManageVenueScreen(
      {super.key, required this.placeId, required this.placeName});
  final String placeId;
  final String placeName;

  @override
  State<ManageVenueScreen> createState() => _ManageVenueScreenState();
}

class _ManageVenueScreenState extends State<ManageVenueScreen> {
  bool _saving = false;
  List<String> _photoPaths = [];
  final _menuCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  // Opening hours state: day → (open, close)
  final Map<String, _HourRange> _hours = {
    'Mon': _HourRange('09:00', '22:00', isOpen: true),
    'Tue': _HourRange('09:00', '22:00', isOpen: true),
    'Wed': _HourRange('09:00', '22:00', isOpen: true),
    'Thu': _HourRange('09:00', '22:00', isOpen: true),
    'Fri': _HourRange('12:00', '23:00', isOpen: true),
    'Sat': _HourRange('10:00', '23:00', isOpen: true),
    'Sun': _HourRange('', '', isOpen: false),
  };

  @override
  void dispose() {
    _menuCtrl.dispose();
    _phoneCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final photoCount = _photoPaths.length;
    await Future.delayed(Duration(milliseconds: 1000 + photoCount * 100));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Changes saved successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
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
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.neutral900,
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage listing',
                style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            Text(
              widget.placeName,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral500),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              icon: Icons.photo_library_outlined,
              title: 'Official photos',
              subtitle: 'Up to 10 photos shown on your listing',
              animationIndex: 0,
              child: PhotoPicker(
                maxPhotos: 10,
                onChanged: (paths) => setState(() => _photoPaths = paths),
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _SectionCard(
              icon: Icons.schedule_outlined,
              title: 'Opening hours',
              subtitle: 'Toggle days closed/open and set times',
              animationIndex: 1,
              child: Column(
                children: _hours.entries.map((e) {
                  return _HourRow(
                    day: e.key,
                    range: e.value,
                    onChanged: (updated) =>
                        setState(() => _hours[e.key] = updated),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _SectionCard(
              icon: Icons.menu_book_outlined,
              title: 'Menu',
              subtitle: 'Add a link to your menu or PDF',
              animationIndex: 2,
              child: TextField(
                controller: _menuCtrl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://your-menu-link.com',
                  prefixIcon: const Icon(Icons.link_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s12, vertical: AppSizes.s12),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _SectionCard(
              icon: Icons.contact_phone_outlined,
              title: 'Contact info',
              subtitle: 'Shown to visitors on your listing',
              animationIndex: 3,
              child: Column(
                children: [
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  TextField(
                    controller: _websiteCtrl,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: 'Website',
                      prefixIcon: const Icon(Icons.language_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s32),

            PrimaryButton(
              label: 'Save changes',
              loading: _saving,
              onTap: _save,
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: AppAnimations.normal)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppSizes.s32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.animationIndex,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final int animationIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900,
                        )),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.neutral500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s16),
          child,
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationIndex * 80))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.06, end: 0);
  }
}

class _HourRange {
  const _HourRange(this.open, this.close, {required this.isOpen});
  final String open;
  final String close;
  final bool isOpen;

  _HourRange copyWith({String? open, String? close, bool? isOpen}) =>
      _HourRange(open ?? this.open, close ?? this.close,
          isOpen: isOpen ?? this.isOpen);
}

class _HourRow extends StatelessWidget {
  const _HourRow(
      {required this.day, required this.range, required this.onChanged});
  final String day;
  final _HourRange range;
  final ValueChanged<_HourRange> onChanged;

  Future<void> _pickTime(
      BuildContext context, String current, ValueChanged<String> onPick) async {
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.firstOrNull ?? '9') ?? 9,
      minute: int.tryParse(parts.lastOrNull ?? '0') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      onPick(
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s6),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(day,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral900,
                )),
          ),
          Switch(
            value: range.isOpen,
            onChanged: (v) => onChanged(range.copyWith(isOpen: v)),
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          if (range.isOpen) ...[
            const SizedBox(width: AppSizes.s8),
            _TimeChip(
              time: range.open.isEmpty ? '09:00' : range.open,
              onTap: () => _pickTime(context, range.open, (t) {
                onChanged(range.copyWith(open: t));
              }),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.s6),
              child: Text('—',
                  style: TextStyle(color: AppColors.neutral300, fontSize: 13)),
            ),
            _TimeChip(
              time: range.close.isEmpty ? '22:00' : range.close,
              onTap: () => _pickTime(context, range.close, (t) {
                onChanged(range.copyWith(close: t));
              }),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.only(left: AppSizes.s8),
              child: Text('Closed',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral300,
                      fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.time, required this.onTap});
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s10, vertical: AppSizes.s4),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Text(time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral900,
            )),
      ),
    );
  }
}
