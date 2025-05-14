import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  
  ProductsLoaded(this.products);
  
  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;
  
  ProductsError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProductAdded extends ProductsState {
  final Product product;
  
  ProductAdded(this.product);
  
  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends ProductsState {
  final Product product;
  
  ProductUpdated(this.product);
  
  @override
  List<Object?> get props => [product];
}

class ProductDeleted extends ProductsState {
  final String id;
  
  ProductDeleted(this.id);
  
  @override
  List<Object?> get props => [id];
}

class ProductActionFailed extends ProductsState {
  final String message;
  
  ProductActionFailed(this.message);
  
  @override
  List<Object?> get props => [message];
}
