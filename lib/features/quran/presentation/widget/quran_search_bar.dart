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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.sp,
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: 'ابحث عن سورة...',
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: isDark ? const Color(0xffAEB8C4) : const Color(0xff98A2B3),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20.sp,
                color: isDark ? const Color(0xffAEB8C4) : const Color(0xff667085),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 13.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}