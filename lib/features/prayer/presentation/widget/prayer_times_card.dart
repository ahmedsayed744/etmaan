import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/prayer_time_model.dart';
import 'prayer_time_item.dart';

class PrayerTimesCard extends StatelessWidget {
  final List<PrayerTimeModel> prayerTimes;
  final PrayerType? nextPrayerType;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
    required this.nextPrayerType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Text(
            'مواقيت الصلاة',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color:
                  theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 7.h),
          ...prayerTimes.map(
            (prayer) {
              return PrayerTimeItem(
                prayer: prayer,
                isNext:
                    prayer.type ==
                    nextPrayerType,
              );
            },
          ),
        ],
      ),
    );
  }
}