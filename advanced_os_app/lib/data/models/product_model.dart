import 'dart:convert';
import 'dart:io';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String title,
    required String description,
    required String imageData,
  }) : super(
    id: id,
    title: title,
    description: description,
    imageData: imageData,
  );
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageData: json['imageData'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageData': imageData,
    };
  }
  
  // For creating a new product with image file
  static Map<String, dynamic> toAddProductFields({
    required String title,
    required String description,
  }) {
    return {
      'Title': title,
      'Description': description,
    };
  }
  
  // For updating a product with image file
  Map<String, dynamic> toUpdateProductFields() {
    return {
      'Title': title,
      'Description': description,
    };
  }
}
