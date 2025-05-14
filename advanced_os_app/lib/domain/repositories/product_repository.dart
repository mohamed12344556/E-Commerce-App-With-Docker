import 'dart:io';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> addProduct(String title, String description, File imageFile);
  Future<Product> updateProduct(String id, String title, String description, File imageFile);
  Future<bool> deleteProduct(String id);
}
