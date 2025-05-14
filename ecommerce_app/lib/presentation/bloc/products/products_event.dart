import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {}

class AddProductEvent extends ProductsEvent {
  final String title;
  final String description;
  final File imageFile;

  AddProductEvent({
    required this.title,
    required this.description,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [title, description, imageFile];
}

// إضافة حدث جديد للويب
class AddProductWebEvent extends ProductsEvent {
  final String title;
  final String description;
  final Uint8List imageBytes;

  AddProductWebEvent({
    required this.title,
    required this.description,
    required this.imageBytes,
  });

  @override
  List<Object?> get props => [title, description, imageBytes];
}

class UpdateProductEvent extends ProductsEvent {
  final String id;
  final String title;
  final String description;
  final File imageFile;

  UpdateProductEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [id, title, description, imageFile];
}

// إضافة حدث جديد للويب
class UpdateProductWebEvent extends ProductsEvent {
  final String id;
  final String title;
  final String description;
  final Uint8List imageBytes;

  UpdateProductWebEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageBytes,
  });

  @override
  List<Object?> get props => [id, title, description, imageBytes];
}

class DeleteProductEvent extends ProductsEvent {
  final String id;

  DeleteProductEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
