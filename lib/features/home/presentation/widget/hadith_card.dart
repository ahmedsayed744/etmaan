import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({super.key, required this.hadith});
  final HadithModel hadith;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            width: 90.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: const Color(0xfffff2c9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                'حديث اليوم',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          Gap(20),
          Text(
            hadith.text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.6,
              color: const Color(0xff25313B),
            ),
          ),
          Gap(5.h),
          Text(
            hadith.bookName,
            style: AppStrings.font18Regular.copyWith(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
            ),
          ),
          Gap(10.h),
        ],
      ),
    );
  }
}
