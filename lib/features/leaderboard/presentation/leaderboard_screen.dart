import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

typedef _WilayaRank = ({
  String wilaya,
  int placeCount,
  int reviewCount,
  double avgScore,
  int trend,
});

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _period = 0; // 0 = This Week, 1 = All Time

  static final _weekData = <_WilayaRank>[
    (wilaya: 'Alger', placeCount: 347, reviewCount: 2340, avgScore: 8.2, trend: 15),
    (wilaya: 'Constantine', placeCount: 189, reviewCount: 1124, avgScore: 8.4, trend: 22),
    (wilaya: 'Annaba', placeCount: 134, reviewCount: 876, avgScore: 8.6, trend: 18),
    (wilaya: 'Oran', placeCount: 198, reviewCount: 1034, avgScore: 7.9, trend: 8),
    (wilaya: 'Blida', placeCount: 87, reviewCount: 534, avgScore: 8.3, trend: 12),
    (wilaya: 'Béjaïa', placeCount: 56, reviewCount: 312, avgScore: 8.1, trend: 25),
    (wilaya: 'Sétif', placeCount: 67, reviewCount: 387, avgScore: 7.7, trend: 7),
    (wilaya: 'Tizi Ouzou', placeCount: 43, reviewCount: 234, avgScore: 7.8, trend: 4),
    (wilaya: 'Boumerdès', placeCount: 34, reviewCount: 187, avgScore: 7.9, trend: 11),
    (wilaya: 'Batna', placeCount: 29, reviewCount: 145, avgScore: 7.5, trend: 3),
  ];

  static final _allTimeData = <_WilayaRank>[
    (wilaya: 'Alger', placeCount: 1247, reviewCount: 8432, avgScore: 8.1, trend: 0),
    (wilaya: 'Oran', placeCount: 634, reviewCount: 3891, avgScore: 7.9, trend: 0),
    (wilaya: 'Constantine', placeCount: 421, reviewCount: 2567, avgScore: 8.3, trend: 0),
    (wilaya: 'Annaba', placeCount: 287, reviewCount: 1834, avgScore: 8.5, trend: 0),
    (wilaya: 'Blida', placeCount: 198, reviewCount: 1203, avgScore: 8.2, trend: 0),
    (wilaya: 'Tizi Ouzou', placeCount: 156, reviewCount: 987, avgScore: 7.7, trend: 0),
    (wilaya: 'Sétif', placeCount: 134, reviewCount: 765, avgScore: 7.6, trend: 0),
    (wilaya: 'Béjaïa', placeCount: 112, reviewCount: 643, avgScore: 8.0, trend: 0),
    (wilaya: 'Boumerdès', placeCount: 89, reviewCount: 445, avgScore: 7.8, trend: 0),
    (wilaya: 'Batna', placeCount: 76, reviewCount: 378, avgScore: 7.5, trend: 0),
  ];

  List<_WilayaRank> get _data => _period == 0 ? _weekData : _allTimeData;

  static const _podiumColors = [
    Color(0xFFFFB300), // gold
    Color(0xFF9E9E9E), // silver
    Color(0xFFBF7340), // bronze
  ];

  static const _podiumLabels = ['🥇', '🥈', '🥉'];

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildPeriodToggle(),
          _buildPodium(),
          _buildRankList(),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: const Color(0xFFF8F8F8),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Wilaya Rankings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.neutral900,
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.screenHorizontalPadding),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department_rounded,
                    size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: AppAnimations.normal),
      ],
    );
  }

  Widget _buildPeriodToggle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s16,
          AppSizes.screenHorizontalPadding, AppSizes.s20,
        ),
        child: Container(
          height: 38,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Row(
            children: [
              _PeriodPill(
                label: 'This Week',
                selected: _period == 0,
                onTap: () => setState(() => _period = 0),
              ),
              _PeriodPill(
                label: 'All Time',
                selected: _period == 1,
                onTap: () => setState(() => _period = 1),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal)
          .slideY(begin: 0.06, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
    );
  }

  Widget _buildPodium() {
    final top3 = _data.take(3).toList();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding,
        ),
        child: Row(
          children: top3.asMap().entries.map((entry) {
            final rank = entry.key;
            final item = entry.value;
            final color = _podiumColors[rank];
            final isFirst = rank == 0;
            return Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  rank == 0 ? 0 : AppSizes.s6,
                  rank == 0 ? 0 : AppSizes.s12,
                  rank == 2 ? 0 : AppSizes.s6,
                  0,
                ),
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.s10, AppSizes.s14, AppSizes.s10, AppSizes.s14),
                decoration: BoxDecoration(
                  color: isFirst
                      ? color.withValues(alpha: 0.10)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: isFirst ? color.withValues(alpha: 0.4) : AppColors.neutral100,
                    width: isFirst ? 1.5 : 1,
                  ),
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.20),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    Text(
                      _podiumLabels[rank],
                      style: TextStyle(fontSize: isFirst ? 28 : 22),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      item.wilaya,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isFirst ? 14 : 12,
                        fontWeight: FontWeight.w800,
                        color: isFirst ? AppColors.neutral900 : AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s6),
                    Text(
                      '${_formatCount(item.reviewCount)} reviews',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isFirst ? AppColors.neutral700 : AppColors.neutral500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isFirst ? 0.15 : 0.10),
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        '${item.avgScore}/10',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 100 + rank * 60))
                  .fadeIn(duration: AppAnimations.normal)
                  .scale(
                    begin: const Offset(0.88, 0.88),
                    end: const Offset(1, 1),
                    curve: AppAnimations.overshoot,
                    duration: AppAnimations.normal,
                  ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRankList() {
    final rest = _data.skip(3).toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i == 0) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding, AppSizes.s20,
                  0, AppSizes.s10),
              child: Text(
                'More wilayas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral500,
                ),
              ),
            ).animate().fadeIn(duration: AppAnimations.normal);
          }
          final dataIndex = i - 1;
          if (dataIndex >= rest.length) return const SizedBox();
          final item = rest[dataIndex];
          final rank = dataIndex + 4;
          return _RankRow(
            rank: rank,
            item: item,
            index: dataIndex,
            formatCount: _formatCount,
            showTrend: _period == 0,
          );
        },
        childCount: rest.length + 1,
      ),
    );
  }
}

// ---- Period Pill ----

class _PeriodPill extends StatelessWidget {
  const _PeriodPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.stateChange,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.neutral900 : AppColors.neutral500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Rank Row ----

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.item,
    required this.index,
    required this.formatCount,
    required this.showTrend,
  });
  final int rank;
  final _WilayaRank item;
  final int index;
  final String Function(int) formatCount;
  final bool showTrend;

  @override
  Widget build(BuildContext context) {
    final trendPositive = item.trend > 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.screenHorizontalPadding, 0,
        AppSizes.screenHorizontalPadding, AppSizes.s8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s14,
        vertical: AppSizes.s12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.neutral500,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s10),
          // Wilaya initial circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                item.wilaya[0],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.wilaya,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatCount(item.placeCount)} places · ${formatCount(item.reviewCount)} reviews',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          // Score + trend
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.avgScore}/10',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.scoreColor(item.avgScore),
                ),
              ),
              if (showTrend && item.trend != 0) ...[
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 12,
                      color: trendPositive ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${item.trend}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: trendPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 + index * 50))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(begin: 0.04, end: 0, curve: AppAnimations.enter, duration: AppAnimations.normal);
  }
}
