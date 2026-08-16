import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingImage extends StatelessWidget {
  const OnBoardingImage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: 250.w,
      child: Image.asset(image, fit: BoxFit.contain),
    );
  }
}
