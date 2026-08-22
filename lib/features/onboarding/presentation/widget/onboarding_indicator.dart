import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../cubit/onboarding_cubit.dart';

class OnBoardingIndicator extends StatelessWidget {
  const OnBoardingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnBoardingCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return SmoothPageIndicator(
      controller: cubit.pageController,
      count: 3,
      effect: ExpandingDotsEffect(
        dotHeight: 8.h,
        dotWidth: 8.w,
        expansionFactor: 3,
        spacing: 8,
        activeDotColor: colorScheme.primary,
        dotColor: colorScheme.outlineVariant,
      ),
    );
  }
}