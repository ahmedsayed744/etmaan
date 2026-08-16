import 'package:etmaan/features/azkar/presentation/widget/azkar_categories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/azkar_category_model.dart';

class AzkarCategoryGrid extends StatelessWidget {
  final List<AzkarCategoryModel> categories;
  final ValueChanged<AzkarCategoryModel> onTap;

  const AzkarCategoryGrid({
    super.key,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: 88.h,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return AzkarCategoryCard(
          category: category,
          onTap: () => onTap(category),
        );
      },
    );
  }
}