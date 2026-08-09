import 'package:etmaan/features/home/presentation/view/home_view.dart';
import 'package:etmaan/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:etmaan/features/quran/presentation/view/quran_view.dart';
import 'package:etmaan/features/setting/presentation/view/setting_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:etmaan/root_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case '/OnboardingView':
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case '/RootView':
        return MaterialPageRoute(builder: (_) => const RootView());
      case '/HomeView':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/QuranView':
        return MaterialPageRoute(builder: (_) => const QuranView());
      case '/TasbeehView':
        return MaterialPageRoute(builder: (_) => const TasbeehView());
      case '/SettingView':
        return MaterialPageRoute(builder: (_) => const SettingView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
