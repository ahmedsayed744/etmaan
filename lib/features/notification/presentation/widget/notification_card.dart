import 'package:etmaan/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../data/notification_history_entry.dart';

class NotificationCard extends StatelessWidget {
  final NotificationHistoryEntry entry;

  const NotificationCard({super.key, required this.entry});

  String _formatArabicTime(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '$hour12:$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isVerse = entry.type == 'verse';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkContentContainer : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isVerse
                      ? (isDark ? const Color(0xff1E2735) : AppColors.scaffoldBackgroundColor)
                      : (isDark ? const Color(0xff2A373E) : const Color(0xfffff2c9)),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  entry.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Text(
                _formatArabicTime(entry.scheduledAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkSecondaryText : Colors.grey[600],
                ),
              ),
            ],
          ),
          Gap(18.h),
          Text(
            isVerse ? '( ${entry.body} )' : entry.body,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              height: 1.6,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Gap(12.h),
          if (isVerse && entry.surahName != null)
            Text(
              '${entry.surahName} • ${entry.verseNumber ?? ""}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            )
          else if (!isVerse && entry.bookName != null)
            Text(
              entry.bookName!,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
