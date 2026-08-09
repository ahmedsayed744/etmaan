import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingTitle extends StatelessWidget {
  const OnBoardingTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xff1B2430),
      ),
    );
  }
}