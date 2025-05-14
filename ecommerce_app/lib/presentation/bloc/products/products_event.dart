import 'dart:io';
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

class DeleteProductEvent extends ProductsEvent {
  final String id;
  
  DeleteProductEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}
