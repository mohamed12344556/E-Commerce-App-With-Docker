import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRepositoryImpl(this._productRemoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _productRemoteDataSource.getProducts();
      return products;
    } catch (e) {
      print('Get products error: $e');
      rethrow;
    }
  }

  @override
  Future<Product> addProduct(
    String title,
    String description,
    dynamic image,
  ) async {
    try {
      if (kIsWeb) {
        // في حالة الويب، نتوقع أن تكون الصورة Uint8List
        final product = await _productRemoteDataSource.addProductWeb(
          title: title,
          description: description,
          imageBytes: image as Uint8List,
        );
        return product;
      } else {
        // في حالة التطبيق العادي، نتوقع أن تكون الصورة File
        final product = await _productRemoteDataSource.addProduct(
          title: title,
          description: description,
          imageFile: image as File,
        );
        return product;
      }
    } catch (e) {
      print('Add product error: $e');
      rethrow;
    }
  }

  @override
  Future<Product> updateProduct(
    String id,
    String title,
    String description,
    dynamic image,
  ) async {
    try {
      if (kIsWeb) {
        // في حالة الويب، نتوقع أن تكون الصورة Uint8List
        final product = await _productRemoteDataSource.updateProductWeb(
          id: id,
          title: title,
          description: description,
          imageBytes: image as Uint8List,
        );
        return product;
      } else {
        // في حالة التطبيق العادي، نتوقع أن تكون الصورة File
        final product = await _productRemoteDataSource.updateProduct(
          id: id,
          title: title,
          description: description,
          imageFile: image as File,
        );
        return product;
      }
    } catch (e) {
      print('Update product error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      await _productRemoteDataSource.deleteProduct(id);
      return true;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }
}
