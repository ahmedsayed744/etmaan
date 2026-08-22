import 'package:etmaan/features/quran/data/models/surah_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SurahCard extends StatelessWidget {
  final SurahModel surah;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6).r,
      child: Material(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            height: 62.h,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xff1E2735) : const Color(0xffE7F6EE),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.number}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff27815D),
                      ),
                    ),
                  ),
                ),
      
                SizedBox(width: 10.w),
      
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        surah.name,
                        textDirection:
                            TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
      
                      SizedBox(height: 2.h),
      
                      Text(
                        '${surah.revelationType} • آية ${surah.versesCount} • ${surah.englishName}',
                        textDirection:
                            TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isDark ? const Color(0xffAEB8C4) : const Color(0xff98A2B3),
                        ),
                      ),
                    ],
                  ),
                ),
      
                SizedBox(width: 8.w),
      
                Icon(
                  Icons.chevron_left,
                  size: 18.sp,
                  color: isDark ? const Color(0xffAEB8C4) : const Color(0xff98A2B3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}