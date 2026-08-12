import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _HeaderIcon(
              icon: Icons.favorite_border,
              onTap: () {},
            ),

            SizedBox(width: 10.w),

            _HeaderIcon(
              icon: Icons.bookmark_border,
              onTap: () {},
            ),

            SizedBox(width: 10.w),

            _HeaderIcon(
              icon: Icons.share_outlined,
              onTap: () {},
            ),
          ],
        ),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 7.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffE9F7EF),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'آية اليوم',
            style: AppStrings.font18Regular.copyWith(
              fontSize: 12.sp,
              color: const Color(0xff16865C),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 21.sp,
        color: const Color(0xff68747D),
      ),
    );
  }
}