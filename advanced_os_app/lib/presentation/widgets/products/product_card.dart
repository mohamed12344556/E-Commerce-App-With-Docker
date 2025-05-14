import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Stack(
              children: [
                // Image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: _buildProductImage(),
                ),

                // Edit/Delete buttons
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Row(
                    children: [
                      // Edit button
                      _buildIconButton(
                        Icons.edit,
                        Colors.orange,
                        onEdit,
                        'Edit',
                      ),
                      const SizedBox(width: 8.0),

                      // Delete button
                      _buildIconButton(
                        Icons.delete,
                        Colors.red,
                        onDelete,
                        'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),

                // Description
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    try {
      if (product.imageData.isNotEmpty) {
        final imageBytes = base64Decode(
          product.imageData.replaceFirst(RegExp(r'data:image/\w+;base64,'), ''),
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading image: $error");
              return _buildErrorImage();
            },
          ),
        );
      }
      return _buildErrorImage();
    } catch (e) {
      print("Exception in image rendering: $e");
      return _buildErrorImage();
    }
  }

  Widget _buildErrorImage() {
    return Center(
      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
    String tooltip,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onTap,
        tooltip: tooltip,
        iconSize: 20.0,
        constraints: BoxConstraints(minWidth: 36.0, minHeight: 36.0),
        padding: EdgeInsets.zero,
        splashRadius: 24.0,
      ),
    );
  }
}
