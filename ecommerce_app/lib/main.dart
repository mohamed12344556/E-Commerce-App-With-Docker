import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'services/network/api_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/products/products_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  final apiClient = ApiClient();
  
  // Initialize data sources
  final authDataSource = AuthRemoteDataSource(apiClient);
  final productDataSource = ProductRemoteDataSource(apiClient);
  
  // Initialize repositories
  final authRepository = AuthRepositoryImpl(authDataSource);
  final productRepository = ProductRepositoryImpl(productDataSource);
  
  // Run the app with repositories
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider<ProductsBloc>(
          create: (context) => ProductsBloc(
            productRepository: productRepository,
          ),
        ),
      ],
      child: EcommerceApp(),
    ),
  );
}
