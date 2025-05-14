import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConstants {
  // Base URL
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5163';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5163'; // Android Emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5163'; // iOS Simulator
    } else {
      return 'http://192.168.1.4:5163';
    }
  }

  // Authentication endpoints
  static const String login = '/api/Account/Login';
  static const String register = '/api/Account/Register';
  static const String updateUser = '/api/Account/UpdateUser';

  // Product endpoints
  static const String addItem = '/api/Item/AddItem';
  static const String getItems = '/api/Item/GetItems';
  static const String updateItem = '/api/Item/UpdateItem';
  static const String deleteItem = '/api/Item/DeleteItem';
}
