import 'package:flutter/material.dart';

class AzkarCategoryModel {
  final String title;
  final String jsonPath;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const AzkarCategoryModel({
    required this.title,
    required this.jsonPath,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}