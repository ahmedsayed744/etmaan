import 'package:etmaan/features/onboarding/data/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'onboarding_description.dart';
import 'onboarding_image.dart';
import 'onboarding_title.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key, required this.model});
  final OnBoardingModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        OnBoardingImage(image: model.image),
        Gap(40.h),
        OnBoardingTitle(title: model.title),
        Gap(18.h),
        OnBoardingDescription(description: model.description),

        const Spacer(),
      ],
    );
  }
}
