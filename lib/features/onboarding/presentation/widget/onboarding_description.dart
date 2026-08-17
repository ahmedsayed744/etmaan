import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingDescription extends StatelessWidget {
  const OnBoardingDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: AppStrings.font18Regular.copyWith(
          color: Colors.grey.shade700,
          height: 1.7,
        ),
      ),
    );
  }
}
