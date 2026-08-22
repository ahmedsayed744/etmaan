import 'dart:async';
import 'package:etmaan/core/notifications/notification_router.dart';
import 'package:etmaan/core/notifications/notification_service.dart';
import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/core/theme/app_theme.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/core/theme/cubit/theme_state.dart';
import 'package:etmaan/features/azkar/presentation/view/azkar_view.dart';
import 'package:etmaan/features/home/presentation/view/home_view.dart';
import 'package:etmaan/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:etmaan/features/prayer/data/datasource/location_datasource.dart';
import 'package:etmaan/features/prayer/data/datasource/prayer_datasource.dart';
import 'package:etmaan/features/prayer/data/repo/prayer_repo_imp.dart';
import 'package:etmaan/features/quran/presentation/view/quran_view.dart';
import 'package:etmaan/features/setting/logic/cubit/setting_cubit.dart';
import 'package:etmaan/features/setting/presentation/view/setting_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:etmaan/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Etmaan extends StatefulWidget {
  const Etmaan({super.key});

  @override
  State<Etmaan> createState() => _EtmaanState();
}

class _EtmaanState extends State<Etmaan> {
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  StreamSubscription<NotificationResponse>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    _notificationTapSubscription = NotificationService
        .instance.onNotificationTap
        .listen(_handleNotificationTap);
  }

  void _handleNotificationTap(NotificationResponse response) {
    final context = _navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    NotificationRouter.handle(context, response);
  }

  @override
  void dispose() {
    _notificationTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingCubit(
            prayerRepo: PrayerRepoImp(
              locationDataSource: LocationDataSource(),
              prayerDataSource: PrayerDataSource(),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            ensureScreenSize: true,
            builder: (_, child) {
              return MaterialApp(
                navigatorKey: _navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'اطمئن',
                locale: const Locale('ar'),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: child!,
                  );
                },
                home: const OnboardingView(),
                routes: {
                  Routs.onboardingView: (context) =>
                      const OnboardingView(),
                  Routs.rootView: (context) {
                    final args =
                        ModalRoute.of(context)?.settings.arguments;
                    final index = args is int ? args : RootView.homeTab;
                    return RootView(initialIndex: index);
                  },
                  Routs.homeView: (context) => const HomeView(),
                  Routs.quranView: (context) => const QuranView(),
                  Routs.tasbeehView: (context) =>
                      const TasbeehView(),
                  Routs.settingView: (context) =>
                      const SettingView(),
                  Routs.azkarView: (context) => const AzkarView(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
