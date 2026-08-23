import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/etmaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Etmaan app smoke test renders root app widget', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SharedPreferences.setMockInitialValues({});
    await CacheHelper().init();

    await tester.pumpWidget(
      BlocProvider(create: (_) => ThemeCubit(), child: const Etmaan()),
    );
    await tester.pump();

    expect(find.byType(Etmaan), findsOneWidget);
  });
}
