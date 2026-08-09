import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/etmaan.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  runApp(const Etmaan());
}

