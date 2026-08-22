import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/tasbeeh/data/model/tasbeeh_monthly_stats_model.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_statistics_cubit.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_statistics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TasbeehStatisticsBottomSheet extends StatelessWidget {
  const TasbeehStatisticsBottomSheet({super.key});

  static void show(BuildContext context, TasbeehStatisticsCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const TasbeehStatisticsBottomSheet(),
      ),
    ).whenComplete(() {
      cubit.clearSelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: BlocBuilder<TasbeehStatisticsCubit, TasbeehStatisticsState>(
        builder: (context, state) {
          if (state is TasbeehStatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TasbeehStatisticsEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                Gap(16.h),
                Text(
                  'لا توجد إحصائيات بعد',
                  style: AppStrings.font18Regular.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
              ],
            );
          }
          
          if (state is TasbeehStatisticsLoaded) {
            if (state.selectedMonth != null) {
              return _MonthDetailView(month: state.selectedMonth!);
            }
            return _MonthsListView(months: state.months);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MonthsListView extends StatelessWidget {
  final List<TasbeehMonthlyStats> months;

  const _MonthsListView({required this.months});

  String _formatMonth(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) return monthKey;
    
    final year = parts[0];
    final monthNum = int.tryParse(parts[1]) ?? 1;
    
    const monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    if (monthNum < 1 || monthNum > 12) return monthKey;
    
    return '${monthNames[monthNum - 1]} $year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<TasbeehStatisticsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Gap(20.h),
        Text(
          'إحصائيات التسبيح',
          style: AppStrings.font18Regular.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        Gap(16.h),
        Expanded(
          child: ListView.separated(
            itemCount: months.length,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              final month = months[index];
              return InkWell(
                onTap: () => cubit.selectMonth(month.monthKey),
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatMonth(month.monthKey),
                        style: AppStrings.font18Regular.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonthDetailView extends StatelessWidget {
  final TasbeehMonthlyStats month;

  const _MonthDetailView({required this.month});

  String _formatMonth(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) return monthKey;
    
    final year = parts[0];
    final monthNum = int.tryParse(parts[1]) ?? 1;
    
    const monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    if (monthNum < 1 || monthNum > 12) return monthKey;
    
    return '${monthNames[monthNum - 1]} $year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<TasbeehStatisticsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Gap(20.h),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.onSurface),
              onPressed: cubit.clearSelection,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Gap(12.w),
            Text(
              _formatMonth(month.monthKey),
              style: AppStrings.font18Regular.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        Gap(24.h),
        Expanded(
          child: ListView(
            children: [
              _DhikrStatItem(
                name: 'سُبْحَانَ الله',
                count: month.subhanAllah,
                color: const Color(0xFF2E8B68),
              ),
              Gap(12.h),
              _DhikrStatItem(
                name: 'الْحَمْدُ لِلَّه',
                count: month.alhamdulillah,
                color: const Color(0xFF4384ED),
              ),
              Gap(12.h),
              _DhikrStatItem(
                name: 'اللهُ أَكْبَر',
                count: month.allahuAkbar,
                color: const Color(0xFF7F43E4),
              ),
              Gap(12.h),
              _DhikrStatItem(
                name: 'لَا إِلٰهَ إِلَّا الله',
                count: month.laIlahaIllallah,
                color: const Color(0xFFD1B46E),
              ),
              Gap(12.h),
              _DhikrStatItem(
                name: 'أَسْتَغْفِرُ الله',
                count: month.astaghfirullah,
                color: const Color(0xFFE85A5A),
              ),
              Gap(24.h),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي التسبيح',
                      style: AppStrings.font18Regular.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${month.total} مرة',
                      style: AppStrings.font18Regular.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DhikrStatItem extends StatelessWidget {
  final String name;
  final int count;
  final Color color;

  const _DhikrStatItem({
    required this.name,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Gap(12.w),
              Text(
                name,
                style: AppStrings.font18Regular.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          Text(
            '$count مرة',
            style: AppStrings.font18Regular.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
