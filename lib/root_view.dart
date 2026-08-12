import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/features/home/presentation/view/home_view.dart';
import 'package:etmaan/features/quran/presentation/view/quran_view.dart';
import 'package:etmaan/features/setting/presentation/view/setting_view.dart';
import 'package:etmaan/features/tasbeeh/presentation/view/tasbeeh_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});
  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late PageController controller;
  final List<Widget> _screens = const [
    HomeView(),
    QuranView(),
    TasbeehView(),
    SettingView(),
  ];

  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onNavItemTap(int index) {
    setState(() {
      currentScreen = index;
    });
    controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentScreen,
          onTap: _onNavItemTap,
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: _NavItem(
              index: 0,
              currentIndex: currentIndex,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_outlined,
              label: 'الرئيسية',
              onTap: onTap,
            ),
          ),
          Expanded(
            child: _NavItem(
              index: 1,
              currentIndex: currentIndex,
              icon: Icons.menu_book_outlined,
              selectedIcon: Icons.menu_book_rounded,
              label: 'القرآن',
              onTap: onTap,
            ),
          ),

          Expanded(
            child: _NavItem(
              index: 2,
              currentIndex: currentIndex,
              icon: Icons.sync_outlined,
              selectedIcon: Icons.sync_rounded,
              label: 'السبحة',
              onTap: onTap,
            ),
          ),
          Expanded(
            child: _NavItem(
              index: 4,
              currentIndex: currentIndex,
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_outlined,
              label: 'الإعدادات',
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ValueChanged<int> onTap;
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 210, 214, 213)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                size: 22.r,
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFF667085),
              ),
            ),

            SizedBox(height: 2.h),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFF667085),
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
