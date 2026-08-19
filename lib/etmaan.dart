import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/core/theme/app_theme.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/core/theme/cubit/theme_state.dart';
import 'package:etmaan/features/azkar/presentation/view/azkar_view.dart';
import 'package:etmaan/features/home/presentation/view/home_view.dart';
import 'package:etmaan/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:etmaan/features/quran/presentation/view/quran_view.dart';
import 'package:etmaan/features/setting/presentation/view/setting_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:etmaan/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Etmaan extends StatelessWidget {
  const Etmaan({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          ensureScreenSize: true,
          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'اطمئن',
              locale: const Locale('ar'),
              // Light Theme
              theme: AppTheme.lightTheme,
              // Dark Theme
              darkTheme: AppTheme.darkTheme,
              // Current Theme
              themeMode: state.themeMode,
              builder: (context, child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                );
              },
              home: const OnboardingView(),
              routes: {
                Routs.onboardingView: (context) => const OnboardingView(),
                Routs.rootView: (context) => const RootView(),
                Routs.homeView: (context) => const HomeView(),
                Routs.quranView: (context) => const QuranView(),
                Routs.tasbeehView: (context) => const TasbeehView(),
                Routs.settingView: (context) => const SettingView(),
                Routs.azkarView: (context) => const AzkarView(),
              },
            );
          },
        );
      },
    );
  }
}
