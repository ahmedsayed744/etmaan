import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastReadCard extends StatelessWidget {
  final String surahName;
  final int currentPage;
  final int totalPages;
  final double progress;
  final VoidCallback onContinue;

  const LastReadCard({
    super.key,
    required this.surahName,
    required this.currentPage,
    required this.totalPages,
    required this.progress,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2B8C67),
            Color(0xff3AA875),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'آخر قراءة',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: .85,
                    ),
                    fontSize: 11.sp,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  surahName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  'الصفحة $currentPage من $totalPages',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: .8,
                    ),
                    fontSize: 11.sp,
                  ),
                ),

                SizedBox(height: 14.h),

                SizedBox(
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xff27815D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(11.r),
                      ),
                    ),
                    child: Text(
                      'متابعة القراءة',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          SizedBox(
            width: 65.w,
            height: 65.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor:
                      Colors.white.withValues(
                    alpha: .18,
                  ),
                  valueColor:
                      const AlwaysStoppedAnimation(
                    Color(0xffE6B958),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
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