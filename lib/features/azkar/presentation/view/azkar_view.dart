import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/azkar/presentation/widget/azkar_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/azkar_category_model.dart';
import '../widget/azkar_category_grid.dart';
import 'azkar_details_view.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({super.key});

  void _openCategory(BuildContext context, AzkarCategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AzkarDetailsView(
          title: category.title,
          jsonPath: category.jsonPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'الأذكار',
          style: AppStrings.font18Regular.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر الفئة',
              style: AppStrings.font18Regular.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            Gap(15),

            AzkarCategoryGrid(
              categories: AzkarCategories.items,
              onTap: (category) {
                _openCategory(context, category);
              },
            ),
          ],
        ),
      ),
    );
  }
}
