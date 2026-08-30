import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:etmaan/core/notifications/notification_service.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/etmaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:etmaan/core/statistics/cubit/statistics_cubit.dart';
import 'package:etmaan/core/statistics/datasource/statistics_local_datasource.dart';
import 'package:etmaan/core/statistics/repo/statistics_repo_imp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  try {
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  await CacheHelper().init();

  // Default prayer notifications to enabled on first launch so Adhan schedules automatically.
  final cache = CacheHelper();
  if (cache.getData(key: CacheKeys.prayerNotificationsEnabled) == null) {
    await cache.saveData(key: CacheKeys.prayerNotificationsEnabled, value: true);
  }

  await NotificationService.instance.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) => StatisticsCubit(
            StatisticsRepoImp(StatisticsLocalDataSource()),
          )..initialize(),
        ),
      ],
      child: const Etmaan(),
    ),
  );
}
