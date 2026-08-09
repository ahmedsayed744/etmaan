import 'package:dio/dio.dart';
import 'package:etmaan/core/api/end_points.dart';
import 'package:etmaan/core/cache/cache_helper.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = CacheHelper().getData(key: ApiKey.token);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
