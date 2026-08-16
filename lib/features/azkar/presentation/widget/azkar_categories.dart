import 'package:etmaan/features/azkar/data/models/azkar_category_model.dart';
import 'package:flutter/material.dart';

class AzkarCategories {
  static const List<AzkarCategoryModel> items = [
    AzkarCategoryModel(
      title: 'أذكار الصباح',
      jsonPath: 'assets/data/azkar/morning.json',
      icon: Icons.cloud_outlined,
      iconColor: Color(0xff111827),
      backgroundColor: Color(0xfffff1c4),
    ),

    AzkarCategoryModel(
      title: 'أذكار المساء',
      jsonPath: 'assets/data/azkar/evening.json',
      icon: Icons.nightlight_round,
      iconColor: Color(0xff7C3AED),
      backgroundColor: Color(0xffeee7ff),
    ),

    AzkarCategoryModel(
      title: 'أذكار النوم',
      jsonPath: 'assets/data/azkar/sleep.json',
      icon: Icons.nightlight_outlined,
      iconColor: Color(0xff2563EB),
      backgroundColor: Color(0xffdff2ff),
    ),

    AzkarCategoryModel(
      title: 'أذكار الصلاة',
      jsonPath: 'assets/data/azkar/prayer.json',
      icon: Icons.pan_tool_alt_outlined,
      iconColor: Color(0xff198754),
      backgroundColor: Color(0xffe5f7ee),
    ),

    AzkarCategoryModel(
      title: 'أذكار السفر',
      jsonPath: 'assets/data/azkar/travel.json',
      icon: Icons.flight_takeoff,
      iconColor: Color(0xffEF4444),
      backgroundColor: Color(0xffffe1e1),
    ),

    AzkarCategoryModel(
      title: 'أذكار المنزل',
      jsonPath: 'assets/data/azkar/home.json',
      icon: Icons.home_outlined,
      iconColor: Color(0xff16A34A),
      backgroundColor: Color(0xffd9f8e9),
    ),
  ];
}