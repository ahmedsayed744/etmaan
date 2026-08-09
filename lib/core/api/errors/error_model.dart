
import 'package:etmaan/core/api/end_points.dart';

class ErrorModel {
  final bool status;
  final int code;
  final String errorMessage;

  ErrorModel({
    required this.status,
    required this.errorMessage,
    required this.code,
  });
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      status: jsonData[ApiKey.status] ?? false,
      errorMessage: jsonData[ApiKey.message] ?? '',
      code: jsonData[ApiKey.code] ?? 0,
    );
  }
}
