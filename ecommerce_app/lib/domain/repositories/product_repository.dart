import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  // دعم النظامين
  Future<Product> addProduct(
    String title,
    String description,
    dynamic image, // يمكن أن يكون File أو Uint8List
  );

  Future<Product> updateProduct(
    String id,
    String title,
    String description,
    dynamic image, // يمكن أن يكون File أو Uint8List
  );

  Future<bool> deleteProduct(String id);
}
