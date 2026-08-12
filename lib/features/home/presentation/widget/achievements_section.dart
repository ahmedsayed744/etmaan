import 'package:etmaan/features/home/presentation/widget/achievement_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'إنجازات اليوم',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff111827),
          ),
        ),

        SizedBox(height: 10.h),

        Row(
          children: [
            Expanded(
              child: AchievementItem(
                value: '8',
                label: 'صفحة',
                icon: Icons.menu_book_outlined,
                iconColor: const Color(0xff198754),
                backgroundColor: const Color(0xffE8F7EF),
                valueColor: const Color(0xff198754),
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: AchievementItem(
                value: '350',
                label: 'مرة',
                icon: Icons.sync,
                iconColor: const Color(0xffD8A63C),
                backgroundColor: const Color(0xfffff5df),
                valueColor: const Color(0xffD8A63C),
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: AchievementItem(
                value: '0',
                label: 'حزب',
                icon: Icons.check,
                iconColor: const Color(0xff7C3AED),
                backgroundColor: const Color(0xffF0E9FF),
                valueColor: const Color(0xff7C3AED),
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: AchievementItem(
                value: '24',
                label: 'دقيقة',
                icon: Icons.access_time,
                iconColor: const Color(0xff3B82F6),
                backgroundColor: const Color(0xffEAF2FF),
                valueColor: const Color(0xff3B82F6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}