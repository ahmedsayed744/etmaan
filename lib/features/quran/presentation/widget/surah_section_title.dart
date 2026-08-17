import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurahSectionTitle extends StatelessWidget {
  const SurahSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'قائمة السور',
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xff111827),
      ),
    );
  }
}