import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/setting/logic/cubit/setting_cubit.dart';
import 'package:etmaan/features/setting/logic/cubit/setting_state.dart';
import 'package:etmaan/features/setting/presentation/widget/notification_setting_tile.dart';
import 'package:etmaan/features/setting/presentation/widget/setting_header.dart';
import 'package:etmaan/features/setting/presentation/widget/setting_stats.dart';
import 'package:etmaan/features/setting/presentation/widget/theme_setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/theme/cubit/theme_state.dart';

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
        builder: (context, themeState) {
          return BlocBuilder<SettingCubit, SettingState>(
            builder: (context, settingState) {
              final isDark = themeState.isDark;

              return ListView(
                padding: EdgeInsets.all(15.w),
                children: [
                  const SettingHeader(),
                  Gap(20.h),
                  const SettingStats(
                    days: 15,
                    pages: 142,
                    tasbeeh: 8200,
                  ),
                  Gap(20.h),
                  ThemeSettingTile(
                    isDark: themeState.isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().setDarkMode(value);
                    },
                  ),
                  Gap(15.h),
                  Text(
                    'الإشعارات',
                    style: AppStrings.font18Regular.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  Gap(8.h),
                  NotificationSettingTile(
                    title: 'تذكير القرآن',
                    icon: Icons.menu_book_outlined,
                    iconBackground: isDark
                        ? const Color(0xff102E20)
                        : const Color(0xffE8F7EF),
                    value: settingState.quranReminderEnabled,
                    onChanged: context.read<SettingCubit>().setQuranReminder,
                  ),
                  NotificationSettingTile(
                    title: 'أذكار الصباح',
                    icon: Icons.wb_sunny_outlined,
                    iconBackground: isDark
                        ? const Color(0xff3D2B0F)
                        : const Color(0xfffff1c4),
                    value: settingState.morningAzkarEnabled,
                    onChanged: context.read<SettingCubit>().setMorningAzkar,
                  ),
                  NotificationSettingTile(
                    title: 'أذكار المساء',
                    icon: Icons.nightlight_round,
                    iconBackground: isDark
                        ? const Color(0xff2A1C42)
                        : const Color(0xffF0E9FF),
                    value: settingState.eveningAzkarEnabled,
                    onChanged: context.read<SettingCubit>().setEveningAzkar,
                  ),
                  NotificationSettingTile(
                    title: 'تذكير الجمعة',
                    icon: Icons.calendar_today_outlined,
                    iconBackground: isDark
                        ? const Color(0xff1E2735)
                        : const Color(0xffEEF0ED),
                    value: settingState.fridayReminderEnabled,
                    onChanged: context.read<SettingCubit>().setFridayReminder,
                  ),
                  NotificationSettingTile(
                    title: 'رسائل تحفيزية',
                    icon: Icons.favorite_outline,
                    iconBackground: isDark
                        ? const Color(0xff3D1919)
                        : const Color(0xffffe8e8),
                    value: settingState.motivationalEnabled,
                    onChanged: context.read<SettingCubit>().setMotivational,
                  ),
                  NotificationSettingTile(
                    title: 'تنبيهات الصلاة',
                    icon: Icons.mosque_outlined,
                    iconBackground: isDark
                        ? const Color(0xff253036)
                        : const Color(0xffdff2ff),
                    value: settingState.prayerNotificationsEnabled,
                    onChanged:
                        context.read<SettingCubit>().setPrayerNotifications,
                  ),
                  Gap(15.h),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
