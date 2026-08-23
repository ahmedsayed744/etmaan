import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () async {
          await CacheHelper().saveData(
            key: CacheKeys.isOnBoardingVisited,
            value: true,
          );
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, Routs.rootView);
        },
        child: Text(
          "تخطي",
          style: AppStrings.font18Regular.copyWith(
            fontSize: 16.sp,
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
