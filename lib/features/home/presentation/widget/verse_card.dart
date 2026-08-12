import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class VerseCard extends StatelessWidget {
  final VerseModel verse;
  const VerseCard({super.key, required this.verse});

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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(50).r,
            ),
            child: Text(
              'آية اليوم',
              style: AppStrings.font18Regular.copyWith(
                color: AppColors.primaryColor,
                fontSize: 16.sp,
              ),
            ),
          ),
          Gap(15.h),
          Center(
            child: Text('( ${verse.text} )', style: AppStrings.font32Bold),
          ),
          const SizedBox(height: 16),
          Text(
            '${verse.surahName} - الآية ${verse.verseNumber}',
            textDirection: TextDirection.rtl,
            style: AppStrings.font18Regular.copyWith(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
