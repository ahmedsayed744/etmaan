import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/azkar/presentation/view/azkar_view.dart';
import 'package:etmaan/features/prayer/presentation/view/prayer_view.dart';
import 'package:etmaan/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ToolsSection extends StatelessWidget {
  final ValueChanged<int>? onSelectTab;

  const ToolsSection({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأدوات',
          style: AppStrings.font18Regular.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        Gap(10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToolItem(
              title: 'الأذكار',
              icon: Icons.nightlight_outlined,
              iconColor: const Color(0xff7C3AED),
              backgroundColor: isDark
                  ? const Color(0xff2A1C42)
                  : const Color(0xffF0E9FF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AzkarView()),
                );
              },
            ),
            ToolItem(
              title: 'السبحة',
              icon: Icons.sync,
              iconColor: const Color(0xffF59E0B),
              backgroundColor: isDark
                  ? const Color(0xff3D2B0F)
                  : const Color(0xfffff4d6),
              onTap: () => onSelectTab?.call(RootView.tasbeehTab),
            ),
            ToolItem(
              title: 'القرآن',
              icon: Icons.menu_book_outlined,
              iconColor: const Color(0xff198754),
              backgroundColor: isDark
                  ? const Color(0xff102E20)
                  : const Color(0xffE8F7EF),
              onTap: () => onSelectTab?.call(RootView.quranTab),
            ),

            ToolItem(
              title: 'الأذان',
              icon: Icons.mosque,
              iconColor: const Color(0xffEF4444),
              backgroundColor: isDark
                  ? const Color(0xff3D1919)
                  : const Color(0xffffe8e8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrayerView()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ToolItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ToolItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon, size: 23.sp, color: iconColor),
            ),
            Gap(8.h),
            Text(
              title,
              style: AppStrings.font18Regular.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
