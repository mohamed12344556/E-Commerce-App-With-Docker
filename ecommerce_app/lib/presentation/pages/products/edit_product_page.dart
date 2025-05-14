import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/product.dart';
import '../../bloc/products/products_bloc.dart';
import '../../bloc/products/products_event.dart';
import '../../bloc/products/products_state.dart';
import '../../widgets/common/loading_indicator.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // تغيير متغيرات الصورة
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageData;

  final _imagePicker = ImagePicker();
  late Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // الحصول على المنتج من المعاملات
    _product = ModalRoute.of(context)!.settings.arguments as Product;
    _titleController.text = _product.title;
    _descriptionController.text = _product.description;
    _imageData = _product.imageData;

    // إذا كان هناك بيانات صورة، حاول فك ترميزها إلى Uint8List للاستخدام في الويب
    if (_imageData != null && _imageData!.isNotEmpty) {
      try {
        final String base64Image = _imageData!.replaceFirst(
          RegExp(r'data:image/\w+;base64,'),
          '',
        );
        _imageBytes = base64Decode(base64Image);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // في حالة الويب، نحتاج إلى قراءة الصورة كـ bytes
          pickedFile.readAsBytes().then((value) {
            setState(() {
              _imageBytes = value;
              _imageData = null; // إزالة الصورة السابقة عند اختيار صورة جديدة
            });
          });
        } else {
          // في حالة تطبيقات الموبايل
          _imageFile = File(pickedFile.path);
          _imageData = null; // إزالة الصورة السابقة عند اختيار صورة جديدة
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null && _imageBytes == null && _imageData == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select an image')));
        return;
      }

      if (kIsWeb) {
        if (_imageBytes != null) {
          context.read<ProductsBloc>().add(
            UpdateProductWebEvent(
              id: _product.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              imageBytes: _imageBytes!,
            ),
          );
        } else {
          // في حالة عدم تغيير الصورة، أخبر المستخدم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a new image to update the product'),
            ),
          );
        }
      } else {
        if (_imageFile != null) {
          context.read<ProductsBloc>().add(
            UpdateProductEvent(
              id: _product.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              imageFile: _imageFile!,
            ),
          );
        } else {
          // في حالة عدم تغيير الصورة، أخبر المستخدم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a new image to update the product'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is ProductActionFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProductsLoading) {
            return Center(child: LoadingIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // مربع اختيار الصورة
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: _getImageWidget(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // حقل العنوان
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل الوصف
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // زر الإرسال
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'UPDATE PRODUCT',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة مساعدة لعرض الصورة بناءً على البيئة
  Widget _getImageWidget() {
    if (kIsWeb) {
      if (_imageBytes != null) {
        // عرض الصورة الجديدة المختارة في الويب
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _imageBytes!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      } else if (_imageData != null && _imageData!.isNotEmpty) {
        // عرض الصورة الموجودة مسبقًا في الويب
        try {
          final String base64Image = _imageData!.replaceFirst(
            RegExp(r'data:image/\w+;base64,'),
            '',
          );
          final imageBytes = base64Decode(base64Image);

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorImage();
              },
            ),
          );
        } catch (e) {
          return _buildErrorImage();
        }
      }
    } else {
      // عرض الصورة في تطبيقات الموبايل
      if (_imageFile != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _imageFile!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      } else if (_imageData != null && _imageData!.isNotEmpty) {
        try {
          final String base64Image = _imageData!.replaceFirst(
            RegExp(r'data:image/\w+;base64,'),
            '',
          );
          final imageBytes = base64Decode(base64Image);

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorImage();
              },
            ),
          );
        } catch (e) {
          return _buildErrorImage();
        }
      }
    }

    // عرض أيقونة إضافة صورة إذا لم تكن هناك صورة
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          size: 50,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to change product image',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildErrorImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 50,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            'Unable to load image',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
