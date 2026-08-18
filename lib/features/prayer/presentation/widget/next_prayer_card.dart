import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String remaining;
  final double progress;

  const NextPrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff287F5E),
            Color(0xff39A875),
          ],
        ),
        borderRadius:
            BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56.w,
            height: 56.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(
                    0.0,
                    1.0,
                  ),
                  strokeWidth: 3,
                  backgroundColor:
                      Colors.white.withValues(
                    alpha: 0.18,
                  ),
                  valueColor:
                      const AlwaysStoppedAnimation(
                    Color(0xffE0B354),
                  ),
                ),
                Text(
                  '${(progress.clamp(0.0, 1.0) * 100).round()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: TextStyle(
                    color:
                        Colors.white.withValues(
                      alpha: 0.75,
                    ),
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  prayerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  prayerTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'متبقي $remaining',
                  style: TextStyle(
                    color:
                        Colors.white.withValues(
                      alpha: 0.72,
                    ),
                    fontSize: 8.sp,
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