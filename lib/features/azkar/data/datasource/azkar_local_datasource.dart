import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/azkar_model.dart';

class AzkarLocalDataSource {
  Future<List<AzkarModel>> getAzkar(
    String jsonPath,
  ) async {
    final jsonString = await rootBundle.loadString(
      jsonPath,
    );

    final List<dynamic> data = jsonDecode(jsonString);

    return data
        .map(
          (item) => AzkarModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}