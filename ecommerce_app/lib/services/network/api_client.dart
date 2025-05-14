import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: 15000),
        receiveTimeout: Duration(milliseconds: 15000),
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // POST request
  // Future<dynamic> post(
  //   String endpoint, {
  //   dynamic data,
  //   Options? options, // إضافة خيار Options
  // }) async {
  //   try {
  //     final response = await _dio.post(
  //       endpoint,
  //       data: data,
  //       options: options, // إضافة الخيارات
  //     );
  //     return response.data;
  //   } on DioException catch (e) {
  //     _handleError(e);
  //   }
  // }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data, options: options);

      // response.data يمكن أن يكون من أنواع مختلفة: String, Map, List...
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // POST request with multipart data (for file upload)
  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    try {
      final formData = FormData();

      // Add text fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files
      for (var entry in files.entries) {
        final file = entry.value;
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // PUT request
  // Future<dynamic> put(
  //   String endpoint, {
  //   dynamic data,
  //   Options? options, // إضافة خيار Options
  // }) async {
  //   try {
  //     final response = await _dio.put(
  //       endpoint,
  //       data: data,
  //       options: options, // إضافة الخيارات
  //     );
  //     return response.data;
  //   } on DioException catch (e) {
  //     _handleError(e);
  //   }
  // }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters, // إضافة معلمات الاستعلام
    Options? options,
  }) async {
    try {
      print('PUT request to: $endpoint');
      print('Query params: $queryParameters');
      print('Data: $data');

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters, // استخدام معلمات الاستعلام
        options: options,
      );

      print('PUT response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('PUT error: $e');
      _handleError(e);
    }
  }

  // PUT request with multipart data (for file upload)
  Future<dynamic> putMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    try {
      final formData = FormData();

      // Add text fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files
      for (var entry in files.entries) {
        final file = entry.value;
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      final response = await _dio.put(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Handle DioError exceptions
  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final int? statusCode = e.response?.statusCode;
        String message = 'Something went wrong. Please try again later.';

        if (e.response?.data != null &&
            e.response?.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = e.response?.data;
          if (responseData.containsKey('message')) {
            message = responseData['message'];
          } else if (responseData.containsKey('error')) {
            message = responseData['error'];
          }
        }

        switch (statusCode) {
          case 400:
            throw Exception('Bad request: $message');
          case 401:
            throw Exception('Unauthorized: $message');
          case 403:
            throw Exception('Forbidden: $message');
          case 404:
            throw Exception('Not found: $message');
          case 500:
            throw Exception('Server error: $message');
          default:
            throw Exception('Error occurred: $message');
        }
      case DioExceptionType.cancel:
        throw Exception('Request was cancelled');
      case DioExceptionType.unknown:
        throw Exception(
          'Network error. Please check your internet connection.',
        );
      default:
        throw Exception('Something went wrong. Please try again later.');
    }
  }
}
