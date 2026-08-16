import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';

class OnBoardingTitle extends StatelessWidget {
  const OnBoardingTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: AppStrings.font32Bold,
    );
  }
}
