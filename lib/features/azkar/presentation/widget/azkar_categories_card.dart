import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/azkar_category_model.dart';

class AzkarCategoryCard extends StatelessWidget {
  final AzkarCategoryModel category;
  final VoidCallback onTap;

  const AzkarCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .05,
                ),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.title,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff111827),
                    height: 1.3,
                  ),
                ),
              ),

              Gap(10.w),

              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: category.backgroundColor,
                  borderRadius:
                      BorderRadius.circular(12.r),
                ),
                child: Icon(
                  category.icon,
                  size: 22.sp,
                  color: category.iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}