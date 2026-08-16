import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/azkar/presentation/view/azkar_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأدوات',
          style: AppStrings.font18Regular.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToolItem(
              title: 'القرآن',
              icon: Icons.menu_book_outlined,
              iconColor: const Color(0xff198754),
              backgroundColor: const Color(0xffE8F7EF),
              onTap: () {},
            ),
            ToolItem(
              title: 'الأذكار',
              icon: Icons.nightlight_outlined,
              iconColor: const Color(0xff7C3AED),
              backgroundColor: const Color(0xffF0E9FF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AzkarView()),
                );
              },
            ),
            ToolItem(
              title: 'السبحة',
              icon: Icons.sync,
              iconColor: const Color(0xffF59E0B),
              backgroundColor: const Color(0xfffff4d6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasbeehView()),
                );
              },
            ),

            ToolItem(
              title: 'المصحف',
              icon: Icons.emoji_events_outlined,
              iconColor: const Color(0xffEF4444),
              backgroundColor: const Color(0xffffe8e8),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class ToolItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ToolItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon, size: 23.sp, color: iconColor),
            ),
            Gap(8.h),
            Text(
              title,
              style: AppStrings.font18Regular.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
