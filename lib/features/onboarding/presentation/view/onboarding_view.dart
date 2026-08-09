import 'package:etmaan/features/onboarding/constants/onboarding_data.dart';
import 'package:etmaan/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:etmaan/features/onboarding/presentation/widget/onboarding_button.dart';
import 'package:etmaan/features/onboarding/presentation/widget/onboarding_indicator.dart';
import 'package:etmaan/features/onboarding/presentation/widget/onboarding_page.dart';
import 'package:etmaan/features/onboarding/presentation/widget/skip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingCubit(),
      child: const _OnBoardingBody(),
    );
  }
}
class _OnBoardingBody extends StatelessWidget {
  const _OnBoardingBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final cubit = context.read<OnBoardingCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  const SkipButton(),
                  Gap(20.h),
                  Expanded(
                    child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: cubit.pageController,
                      onPageChanged: cubit.changePage,
                      itemCount: OnBoardingData.pages.length,
                      itemBuilder: (context, index) {
                        return OnBoardingPage(
                          model: OnBoardingData.pages[index],
                        );
                      },
                    ),
                  ),
                  const OnBoardingIndicator(),
                  Gap(30.h),
                  const OnboardingButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
