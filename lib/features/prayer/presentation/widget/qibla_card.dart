import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'qibla_compass.dart';

class QiblaCard extends StatelessWidget {
  final double qiblaDirection;
  final double? compassHeading;

  const QiblaCard({
    super.key,
    required this.qiblaDirection,
    required this.compassHeading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        12.w,
        10.h,
        12.w,
        12.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration:
                    const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE7F6EE),
                ),
                child: Icon(
                  Icons.explore_outlined,
                  size: 12.sp,
                  color:
                      const Color(0xff2E9568),
                ),
              ),
              const Spacer(),
              Text(
                'اتجاه القبلة',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight:
                      FontWeight.w800,
                  color: theme
                      .colorScheme
                      .onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          QiblaCompass(
            qiblaDirection:
                qiblaDirection,
            compassHeading:
                compassHeading,
          ),

          SizedBox(height: 2.h),

          Text(
            compassHeading == null
                ? 'البوصلة غير متاحة'
                : 'وجّه هاتفك نحو القبلة',
            style: TextStyle(
              fontSize: 8.sp,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.55),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            '${qiblaDirection.round()}°',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight:
                  FontWeight.w800,
              color:
                  const Color(0xff2E9568),
            ),
          ),
        ],
      ),
    );
  }
}