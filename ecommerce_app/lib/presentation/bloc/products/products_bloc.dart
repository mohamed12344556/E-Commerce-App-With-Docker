import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productRepository;
  List<Product> _products = [];

  ProductsBloc({required this.productRepository}) : super(ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<AddProductWebEvent>(_onAddProductWeb); // إضافة معالج للويب
    on<UpdateProductEvent>(_onUpdateProduct);
    on<UpdateProductWebEvent>(_onUpdateProductWeb); // إضافة معالج للويب
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      _products = await productRepository.getProducts();
      emit(ProductsLoaded(_products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  // للأجهزة المحمولة
  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await productRepository.addProduct(
        event.title,
        event.description,
        event.imageFile,
      );

      _products.add(product);
      emit(ProductAdded(product));
      emit(ProductsLoaded(_products));
    } catch (e) {
      emit(ProductActionFailed(e.toString()));
    }
  }

  // للويب
  Future<void> _onAddProductWeb(
    AddProductWebEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await productRepository.addProduct(
        event.title,
        event.description,
        event.imageBytes,
      );

      _products.add(product);
      emit(ProductAdded(product));
      emit(ProductsLoaded(_products));
    } catch (e) {
      emit(ProductActionFailed(e.toString()));
    }
  }

  // للأجهزة المحمولة
  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await productRepository.updateProduct(
        event.id,
        event.title,
        event.description,
        event.imageFile,
      );

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      emit(ProductUpdated(product));
      emit(ProductsLoaded(_products));
    } catch (e) {
      emit(ProductActionFailed(e.toString()));
    }
  }

  // للويب
  Future<void> _onUpdateProductWeb(
    UpdateProductWebEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await productRepository.updateProduct(
        event.id,
        event.title,
        event.description,
        event.imageBytes,
      );

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      emit(ProductUpdated(product));
      emit(ProductsLoaded(_products));
    } catch (e) {
      emit(ProductActionFailed(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final success = await productRepository.deleteProduct(event.id);

      if (success) {
        _products.removeWhere((p) => p.id == event.id);
        emit(ProductDeleted(event.id));
        emit(ProductsLoaded(_products));
      } else {
        emit(ProductActionFailed('Failed to delete product'));
      }
    } catch (e) {
      emit(ProductActionFailed(e.toString()));
    }
  }
}
