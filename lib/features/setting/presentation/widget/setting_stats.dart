import 'package:etmaan/features/setting/presentation/widget/setting_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingStats extends StatelessWidget {
  final int days;
  final int pages;
  final int tasbeeh;

  const SettingStats({
    super.key,
    required this.days,
    required this.pages,
    required this.tasbeeh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SettingStatItem(value: '$days', title: 'يومًا'),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: SettingStatItem(value: '$pages', title: 'صفحة'),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: SettingStatItem(value: '$tasbeeh', title: 'تسبيحة'),
        ),
      ],
    );
  }
}
