import 'package:etmaan/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeSettingTile extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeSettingTile({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Center(
        child: SwitchListTile(
          value: isDark,
          onChanged: onChanged,
          title: Text(
            'الوضع المظلم',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          secondary: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1E2735) : const Color(0xffE7F6EE),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.dark_mode_outlined,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
