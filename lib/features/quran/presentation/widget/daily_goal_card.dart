import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyGoalCard extends StatelessWidget {
  final int completedPages;
  final int targetPages;

  const DailyGoalCard({
    super.key,
    required this.completedPages,
    required this.targetPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final remaining =
        (targetPages - completedPages).clamp(0, targetPages);

    final progress = targetPages == 0
        ? 0.0
        : completedPages / targetPages;

    final percentage =
        (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff253036) : theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'هدف اليوم',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? const Color(0xffAEB8C4) : const Color(0xff667085),
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  '$targetPages صفحات',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    _GoalBadge(
                      text: '$remaining متبقية',
                      color: isDark ? const Color(0xff4A3E26) : const Color(0xffFCEBCB),
                      textColor: const Color(0xffC28117),
                    ),

                    SizedBox(width: 6.w),

                    _GoalBadge(
                      text: '$completedPages مكتملة',
                      color: isDark ? const Color(0xff183D2B) : const Color(0xffE5F6ED),
                      textColor: const Color(0xff27815D),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            width: 62.w,
            height: 62.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor:
                      isDark ? const Color(0xff1E2735) : const Color(0xffE8ECEA),
                  valueColor:
                      const AlwaysStoppedAnimation(
                    Color(0xff27815D),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff27815D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _GoalBadge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}