import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      surfaceTintColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,

      title: Text(
        'الإشعارات',
        style: AppStrings.font18Regular.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),

      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.sp,
          color: isDark ? const Color(0xffAEB8C4) : const Color(0xff667085),
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: theme.dividerTheme.color ?? const Color(0xffE5E7EB),
        ),
      ),
    );
  }
}
