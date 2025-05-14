import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/constants/api_constants.dart';
import '../../services/network/api_client.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSource(this._apiClient);

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiClient.get(ApiConstants.getItems);

    if (response is List) {
      return response.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to parse products data');
    }
  }

  // للأجهزة المحمولة
  Future<ProductModel> addProduct({
    required String title,
    required String description,
    required File imageFile,
  }) async {
    final fields = ProductModel.toAddProductFields(
      title: title,
      description: description,
    );

    final files = {'ImageData': imageFile};

    final response = await _apiClient.postMultipart(
      ApiConstants.addItem,
      fields: fields,
      files: files,
    );

    return ProductModel.fromJson(response);
  }

  // للويب
  Future<ProductModel> addProductWeb({
    required String title,
    required String description,
    required Uint8List imageBytes,
  }) async {
    final fields = ProductModel.toAddProductFields(
      title: title,
      description: description,
    );

    final formData = FormData();

    // إضافة حقول النموذج
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // إضافة الصورة
    formData.files.add(
      MapEntry(
        'ImageData',
        MultipartFile.fromBytes(
          imageBytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    );

    final response = await _apiClient.post(
      ApiConstants.addItem,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ProductModel.fromJson(response);
  }

  // للأجهزة المحمولة
  Future<ProductModel> updateProduct({
    required String id,
    required String title,
    required String description,
    required File imageFile,
  }) async {
    final fields = {'Title': title, 'Description': description};

    final files = {'ImageData': imageFile};

    final response = await _apiClient.putMultipart(
      '${ApiConstants.updateItem}/$id',
      fields: fields,
      files: files,
    );

    return ProductModel.fromJson(response);
  }

  // للويب
  Future<ProductModel> updateProductWeb({
    required String id,
    required String title,
    required String description,
    required Uint8List imageBytes,
  }) async {
    final fields = {'Title': title, 'Description': description};

    final formData = FormData();

    // إضافة حقول النموذج
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // إضافة الصورة
    formData.files.add(
      MapEntry(
        'ImageData',
        MultipartFile.fromBytes(
          imageBytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    );

    final response = await _apiClient.put(
      '${ApiConstants.updateItem}/$id',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ProductModel.fromJson(response);
  }

  Future<String> deleteProduct(String id) async {
    final response = await _apiClient.delete('${ApiConstants.deleteItem}/$id');
    return response.toString();
  }
}
