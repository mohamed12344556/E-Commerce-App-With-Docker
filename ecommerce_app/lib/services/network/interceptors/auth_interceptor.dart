import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return super.onRequest(options, handler);
  }
  
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 && 
        response.data is Map<String, dynamic> && 
        response.data.containsKey('token')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.data['token']);
    }
    
    return super.onResponse(response, handler);
  }
}
