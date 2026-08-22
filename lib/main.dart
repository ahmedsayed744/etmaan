import 'package:etmaan/core/cache/cache_helper.dart';
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
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await CacheHelper().init();
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
