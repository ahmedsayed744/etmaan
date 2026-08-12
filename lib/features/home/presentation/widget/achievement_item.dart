import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color valueColor;

  const AchievementItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: iconColor,
            ),
          ),

          SizedBox(width: 10.w),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),

              Text(
                label,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xff8B9297),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}