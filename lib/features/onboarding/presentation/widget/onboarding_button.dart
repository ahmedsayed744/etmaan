import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final cubit = context.read<OnBoardingCubit>();

        return SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            onPressed: () async {
              if (cubit.isLastPage) {
                await CacheHelper().saveData(
                  key: CacheKeys.isOnBoardingVisited,
                  value: true,
                );
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, Routs.rootView);
              } else {
                cubit.nextPage();
              }
            },
            child: Center(
              child: Text(
                cubit.isLastPage ? "ابدأ الآن" : "التالي",
                style: AppStrings.font18Regular.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
