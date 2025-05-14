import 'package:flutter/material.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/profile/edit_profile_page.dart';
import '../presentation/pages/products/products_page.dart';
import '../presentation/pages/products/add_product_page.dart';
import '../presentation/pages/products/edit_product_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String editProduct = '/products/edit';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => LoginPage(),
        register: (context) => RegisterPage(),
        profile: (context) => ProfilePage(),
        editProfile: (context) => EditProfilePage(),
        products: (context) => ProductsPage(),
        addProduct: (context) => AddProductPage(),
        editProduct: (context) => EditProductPage(),
      };
}
