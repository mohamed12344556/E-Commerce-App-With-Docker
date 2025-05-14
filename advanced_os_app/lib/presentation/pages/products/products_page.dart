import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_routes.dart';
import '../../../domain/entities/product.dart';
import '../../bloc/products/products_bloc.dart';
import '../../bloc/products/products_event.dart';
import '../../bloc/products/products_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/products/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the page loads
    context.read<ProductsBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ProductDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product deleted successfully')),
            );
          } else if (state is ProductActionFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProductsInitial || state is ProductsLoading) {
            return Center(child: LoadingIndicator());
          } else if (state is ProductsLoaded) {
            return _buildProductsList(state.products);
          } else if (state is ProductsError) {
            return _buildErrorWidget(state.message);
          }

          // Default case - show empty list
          return _buildProductsList([]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductsList(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No products available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first product',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsBloc>().add(FetchProductsEvent());
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onEdit: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editProduct,
                arguments: product,
              );
            },
            onDelete: () {
              _showDeleteConfirmationDialog(product);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductsBloc>().add(FetchProductsEvent());
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${product.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProductsBloc>().add(
                    DeleteProductEvent(id: product.id),
                  );
                },
                child: Text(
                  'DELETE',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }
}
