import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/etmaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  runApp(
    BlocProvider(create: (context) => ThemeCubit(), child: const Etmaan()),
  );
}
