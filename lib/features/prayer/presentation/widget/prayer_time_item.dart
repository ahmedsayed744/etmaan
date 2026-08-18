import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/prayer_time_model.dart';

class PrayerTimeItem extends StatelessWidget {
  final PrayerTimeModel prayer;
  final bool isNext;

  const PrayerTimeItem({
    super.key,
    required this.prayer,
    required this.isNext,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute =
        time.minute.toString().padLeft(2, '0');

    final displayHour =
        hour % 12 == 0 ? 12 : hour % 12;

    final period =
        hour >= 12 ? 'م' : 'ص';

    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryColor =
        const Color(0xff2E9568);

    return Container(
      margin: EdgeInsets.only(
        bottom: 2.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: isNext
            ? primaryColor.withValues(
                alpha: 0.10,
              )
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(9.r),
      ),
      child: Row(
        children: [
          Text(
            _formatTime(prayer.time),
            style: TextStyle(
              fontSize: 9.sp,
              color: isNext
                  ? primaryColor
                  : theme.colorScheme.onSurface
                      .withValues(
                    alpha: 0.70,
                  ),
              fontWeight: isNext
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            prayer.name,
            style: TextStyle(
              fontSize: 10.sp,
              color: isNext
                  ? primaryColor
                  : theme.colorScheme.onSurface,
              fontWeight: isNext
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}