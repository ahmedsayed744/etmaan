import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingDescription extends StatelessWidget {
  const OnBoardingDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17.sp,
          color: Colors.grey.shade600,
          height: 1.7,
        ),
      ),
    );
  }
}