import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AzkarActionButton extends StatefulWidget {
  final bool completed;
  final VoidCallback onTap;

  const AzkarActionButton({
    super.key,
    required this.completed,
    required this.onTap,
  });

  @override
  State<AzkarActionButton> createState() => _AzkarActionButtonState();
}

class _AzkarActionButtonState extends State<AzkarActionButton> {
  bool pressed = false;

  Future<void> _handleTap() async {
    if (widget.completed) return;

    setState(() {
      pressed = true;
    });

    widget.onTap();

    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    setState(() {
      pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: pressed ? .97 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 45.h,
          decoration: BoxDecoration(
            color: const Color(0xffE8F6EF),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Text(
              widget.completed ? 'تم الذكر' : 'اضغط للذكر',
              style: AppStrings.font18Regular.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
