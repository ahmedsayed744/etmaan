import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/core/theme/cubit/theme_state.dart';
import 'package:etmaan/features/setting/presentation/widget/setting_header.dart';
import 'package:etmaan/features/setting/presentation/widget/setting_stats.dart';
import 'package:etmaan/features/setting/presentation/widget/theme_setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'الإعدادات',
          style: AppStrings.font18Regular.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(15.w),
            children: [
              const SettingHeader(),

              Gap(20.h),

              const SettingStats(days: 15, pages: 142, tasbeeh: 8200),

              Gap(20.h),

              ThemeSettingTile(
                isDark: state.isDark,
                onChanged: (value) {
                  context.read<ThemeCubit>().setDarkMode(value);
                },
              ),
              Gap(15.h),
            ],
          );
        },
      ),
    );
  }
}
