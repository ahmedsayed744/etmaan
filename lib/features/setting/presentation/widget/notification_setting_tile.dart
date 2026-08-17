import 'package:etmaan/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingTile
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBackground;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationSettingTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBackground,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      secondary: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: 19.sp,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}