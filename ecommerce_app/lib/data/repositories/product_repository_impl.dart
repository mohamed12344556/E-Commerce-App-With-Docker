import 'dart:io';
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
  Future<Product> addProduct(String title, String description, File imageFile) async {
    try {
      final product = await _productRemoteDataSource.addProduct(
        title: title,
        description: description,
        imageFile: imageFile,
      );
      return product;
    } catch (e) {
      print('Add product error: $e');
      rethrow;
    }
  }
  
  @override
  Future<Product> updateProduct(String id, String title, String description, File imageFile) async {
    try {
      final product = await _productRemoteDataSource.updateProduct(
        id: id,
        title: title,
        description: description,
        imageFile: imageFile,
      );
      return product;
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
