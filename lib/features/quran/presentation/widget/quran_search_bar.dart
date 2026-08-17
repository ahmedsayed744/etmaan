import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const QuranSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xff344054),
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن سورة...',
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xff98A2B3),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: const Color(0xff667085),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 13.h,
          ),
        ),
      ),
    );
  }
}