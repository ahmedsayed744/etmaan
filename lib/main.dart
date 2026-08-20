import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/notifications/notification_service.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/etmaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await CacheHelper().init();
  await NotificationService.instance.initialize();

  runApp(
    BlocProvider(create: (context) => ThemeCubit(), child: const Etmaan()),
  );
}
