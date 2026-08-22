import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/tasbeeh_model.dart';

class TasbeehItem extends StatelessWidget {
  final TasbeehModel tasbeeh;
  final bool isSelected;
  final VoidCallback onTap;
  const TasbeehItem({
    super.key,
    required this.tasbeeh,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? tasbeeh.color : colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? tasbeeh.color : colorScheme.outlineVariant,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tasbeeh.color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          tasbeeh.arabicName,
          style: AppStrings.font18Regular.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
