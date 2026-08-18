import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QiblaCompass extends StatelessWidget {
  final double qiblaDirection;
  final double? compassHeading;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.compassHeading,
  });

  double _normalize(double angle) {
    while (angle > 180) {
      angle -= 360;
    }

    while (angle < -180) {
      angle += 360;
    }

    return angle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final angle = compassHeading == null
        ? 0.0
        : _normalize(
            qiblaDirection -
                compassHeading!,
          );

    return SizedBox(
      width: 145.w,
      height: 145.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.14),
                width: 2,
              ),
            ),
          ),
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.05),
              ),
            ),
          ),

          Positioned(
            top: 1.h,
            child: Text(
              'N',
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight:
                    FontWeight.w700,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ),

          Positioned(
            right: 0,
            child: Text(
              'E',
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight:
                    FontWeight.w700,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ),

          Positioned(
            bottom: 1.h,
            child: Text(
              'S',
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight:
                    FontWeight.w700,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ),

          Positioned(
            left: 0,
            child: Text(
              'W',
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight:
                    FontWeight.w700,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ),

          Transform.rotate(
            angle: angle * math.pi / 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 2.w,
                  height: 92.w,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xff2E9568),
                    borderRadius:
                        BorderRadius.circular(10.r),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Icon(
                    Icons.navigation,
                    size: 18.sp,
                    color:
                        const Color(0xff2E9568),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.mosque_outlined,
              size: 11.sp,
              color:
                  const Color(0xffD8A848),
            ),
          ),
        ],
      ),
    );
  }
}