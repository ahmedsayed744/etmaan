import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/home/presentation/widget/achievement_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etmaan/core/statistics/cubit/statistics_cubit.dart';
import 'package:etmaan/core/statistics/cubit/statistics_state.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        final daily = state is StatisticsLoaded ? state.daily : null;
        final pages = daily?.quranPages ?? 0;
        final tasbeeh = daily?.tasbeehCount ?? 0;
        final hizb = daily?.quranHizb ?? 0;
        final sessionMinutes = (daily?.sessionSeconds ?? 0) ~/ 60;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إنجازات اليوم',
              style: AppStrings.font18Regular.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),

            Gap(10.h),

            Row(
              children: [
                Expanded(
                  child: AchievementItem(
                    value: '$pages',
                    label: 'صفحة',
                    icon: Icons.menu_book_outlined,
                    iconColor: const Color(0xff198754),
                    backgroundColor: isDark ? const Color(0xff102E20) : const Color(0xffE8F7EF),
                    valueColor: const Color(0xff198754),
                  ),
                ),

                Gap(15.w),

                Expanded(
                  child: AchievementItem(
                    value: '$tasbeeh',
                    label: 'مرة',
                    icon: Icons.sync,
                    iconColor: const Color(0xffD8A63C),
                    backgroundColor: isDark ? const Color(0xff3D2B0F) : const Color(0xfffff5df),
                    valueColor: const Color(0xffD8A63C),
                  ),
                ),
              ],
            ),

            Gap(15.h),

            Row(
              children: [
                Expanded(
                  child: AchievementItem(
                    value: '$hizb',
                    label: 'حزب',
                    icon: Icons.check,
                    iconColor: const Color(0xff7C3AED),
                    backgroundColor: isDark ? const Color(0xff2A1C42) : const Color(0xffF0E9FF),
                    valueColor: const Color(0xff7C3AED),
                  ),
                ),

                Gap(15.w),

                Expanded(
                  child: AchievementItem(
                    value: '$sessionMinutes',
                    label: 'دقيقة',
                    icon: Icons.access_time,
                    iconColor: const Color(0xff3B82F6),
                    backgroundColor: isDark ? const Color(0xff152744) : const Color(0xffEAF2FF),
                    valueColor: const Color(0xff3B82F6),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
