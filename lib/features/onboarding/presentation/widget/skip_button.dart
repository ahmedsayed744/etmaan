import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/onboarding_data.dart';
import '../cubit/onboarding_cubit.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnBoardingCubit>();

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          cubit.pageController.animateToPage(
            OnBoardingData.pages.length - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Text(
          "تخطي",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}