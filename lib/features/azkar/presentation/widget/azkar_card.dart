import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/azkar_model.dart';
import 'azkar_action_button.dart';

class AzkarCard extends StatelessWidget {
  final AzkarModel azkar;
  final int currentCount;
  final VoidCallback onTap;

  const AzkarCard({
    super.key,
    required this.azkar,
    required this.currentCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = currentCount >= azkar.count;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: completed ? const Color(0xffB9DACE) : const Color(0xffE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (completed)
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff2E8564),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 15.sp),
                ),

              const Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F9F7),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xffB9DACE)),
                ),
                child: Text(
                  '$currentCount / ${azkar.count}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xff2E8564),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Gap(10.h),

          Text(
            azkar.text,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.9,
              fontWeight: FontWeight.w500,
              color: completed
                  ? const Color(0xffC0C4CB)
                  : const Color(0xff26364A),
            ),
          ),

          if (azkar.source != null && azkar.source!.isNotEmpty) ...[
            Gap(8.h),

            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                azkar.source!,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xff8B9199),
                ),
              ),
            ),
          ],

          Gap(12.h),

          AzkarActionButton(completed: completed, onTap: onTap),
        ],
      ),
    );
  }
}
