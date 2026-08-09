import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/features/home/presentation/view/home_view.dart';
import 'package:etmaan/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:etmaan/features/quran/presentation/view/quran_view.dart';
import 'package:etmaan/features/setting/presentation/view/setting_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:etmaan/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Etmaan extends StatelessWidget {
  const Etmaan({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Etmaan',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
          ),
          home: const OnboardingView(),
          routes: {
            Routs.onboardingScreen: (context) => const OnboardingView(),
            Routs.rootView: (context) => const RootView(),
            Routs.homeScreen: (context) => const HomeView(),
            Routs.quranScreen: (context) => const QuranView(),
            Routs.tasbeehScreen: (context) => const TasbeehView(),
            Routs.settingScreen: (context) => const SettingView(),
          },
        );
      },
    );
  }
}
