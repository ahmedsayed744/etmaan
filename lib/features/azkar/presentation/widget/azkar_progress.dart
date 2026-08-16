import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AzkarProgress extends StatelessWidget {
  final int completed;
  final int total;

  const AzkarProgress({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : completed / total;

    final int percentage = (progress * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      child: Row(
        children: [
          Text(
            '$completed / $total',
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xff667085),
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: const Color(0xffE5E7EB),
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xff2D8B68),
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xff2D8B68),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}