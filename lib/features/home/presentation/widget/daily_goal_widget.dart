import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyGoalWidget extends StatelessWidget {
  const DailyGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkContentContainer : const Color.fromARGB(255, 202, 216, 208),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'كل خطوة صغيرة تقربك من هدفك',
            style: AppStrings.font18Regular.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Icon(Icons.spa, size: 24.sp, color: const Color(0xff65A982)),
        ],
      ),
    );
  }
}
