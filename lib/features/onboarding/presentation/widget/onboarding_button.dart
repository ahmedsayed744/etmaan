import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:etmaan/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final cubit = context.read<OnBoardingCubit>();

        return SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            onPressed: () async {
              if (cubit.isLastPage) {
                // Save onboarding in SharedPreferences
                //Navigate to Login/Home
                await CacheHelper().saveData(
                  key: CacheKeys.isOnBoardingVisited,
                  value: true,
                );
                if (!context.mounted) return;
                 Navigator.pushReplacementNamed(context, '/RootView');
              } else {
                cubit.nextPage();
              }
            },
            child: Text(
              cubit.isLastPage ? "ابدأ الآن" : "التالي",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
