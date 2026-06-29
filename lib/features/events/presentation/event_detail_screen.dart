import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.title,
    required this.placeName,
    required this.placeId,
    required this.date,
    required this.imageUrl,
    required this.attendees,
    required this.color,
    this.description,
  });

  final String title;
  final String placeName;
  final String placeId;
  final String date;
  final String imageUrl;
  final int attendees;
  final Color color;
  final String? description;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _rsvp = false;
  bool _loading = false;

  Future<void> _toggleRsvp() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _rsvp = !_rsvp;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_rsvp ? 'You\'re going! See you there.' : 'RSVP cancelled'),
          backgroundColor: _rsvp ? AppColors.success : AppColors.neutral700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendeeCount = widget.attendees + (_rsvp ? 1 : 0);

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: widget.color,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: AppSizes.iconInline),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: widget.color),
                  // Pattern overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PatternPainter(widget.color),
                    ),
                  ),
                  // Event title overlay at bottom
                  Positioned(
                    left: AppSizes.s20,
                    right: AppSizes.s20,
                    bottom: AppSizes.s20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s10, vertical: AppSizes.s4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: Text(
                            widget.date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.s8),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info row
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.place_outlined,
                        label: widget.placeName,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      _InfoChip(
                        icon: Icons.people_outline_rounded,
                        label: '$attendeeCount going',
                        color: AppColors.neutral500,
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: AppAnimations.normal),

                  const SizedBox(height: AppSizes.s24),

                  // Attendees preview
                  _AttendeesRow(count: attendeeCount, isRsvp: _rsvp),

                  const SizedBox(height: AppSizes.s24),

                  // About section
                  Text(
                    'About this event',
                    style: TextStyle(
                      color: AppColors.neutral900,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: AppAnimations.normal),
                  const SizedBox(height: AppSizes.s10),
                  Text(
                    widget.description ??
                        'Join us at ${widget.placeName} for a special evening — '
                            'an exclusive menu, live entertainment, and good company '
                            'with fellow food lovers. Spots are limited, so RSVP to '
                            'secure yours.',
                    style: TextStyle(
                      color: AppColors.neutral700,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: AppAnimations.normal),

                  const SizedBox(height: AppSizes.s24),

                  // Date & time card
                  _EventInfoCard(
                    children: [
                      _EventInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: widget.date),
                      const Divider(height: AppSizes.s24),
                      _EventInfoRow(
                          icon: Icons.schedule_outlined,
                          label: '7:00 PM — 11:00 PM'),
                      const Divider(height: AppSizes.s24),
                      _EventInfoRow(
                          icon: Icons.place_outlined,
                          label: widget.placeName),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: AppAnimations.normal)
                      .slideY(begin: 0.06, end: 0),

                  const SizedBox(height: AppSizes.s32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.s20, AppSizes.s8, AppSizes.s20, AppSizes.s16),
          child: Row(
            children: [
              // Share button
              IconButton.outlined(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_rounded),
                style: IconButton.styleFrom(
                  side: BorderSide(color: AppColors.neutral200),
                  padding: const EdgeInsets.all(AppSizes.s14),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: PrimaryButton(
                  label: _rsvp ? 'Cancel RSVP' : 'RSVP — I\'m going!',
                  loading: _loading,
                  onTap: _toggleRsvp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s10, vertical: AppSizes.s6),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconChip, color: color),
          const SizedBox(width: AppSizes.s6),
          Text(label,
              style: TextStyle(
                  color: AppColors.neutral700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _AttendeesRow extends StatelessWidget {
  const _AttendeesRow({required this.count, required this.isRsvp});
  final int count;
  final bool isRsvp;

  @override
  Widget build(BuildContext context) {
    const initials = ['A', 'S', 'N', 'K', 'M'];
    const colors = [
      Color(0xFFFF6B35),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
      Color(0xFF96CEB4),
      Color(0xFFFFEAA7),
    ];

    return Row(
      children: [
        SizedBox(
          width: initials.length * 24.0 + 12,
          height: 36,
          child: Stack(
            children: initials.asMap().entries.map((e) {
              return Positioned(
                left: e.key * 22.0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors[e.key % colors.length],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          child: Text(
            isRsvp
                ? 'You and $count others are going'
                : '$count people are going',
            style: TextStyle(
                color: AppColors.neutral700,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 150.ms, duration: AppAnimations.normal);
  }
}

class _EventInfoCard extends StatelessWidget {
  const _EventInfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(children: children),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  const _EventInfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconChip, color: AppColors.neutral500),
        const SizedBox(width: AppSizes.s12),
        Text(label,
            style: TextStyle(
                color: AppColors.neutral900,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// Simple geometric pattern painter for the event header
class _PatternPainter extends CustomPainter {
  const _PatternPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(size.width * (i % 3) / 2, size.height * (i ~/ 3) / 2),
        80 + i * 20,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
