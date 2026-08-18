import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const LocationCard({
    super.key,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius:
              BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 27.w,
              height: 27.w,
              decoration: BoxDecoration(
                color:
                    const Color(0xff2E9568)
                        .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color:
                    const Color(0xff2E9568),
              ),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    'الموقع',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: theme
                          .colorScheme
                          .onSurface
                          .withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight:
                          FontWeight.w600,
                      color: theme
                          .colorScheme
                          .onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              size: 16.sp,
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(
                alpha: 0.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}