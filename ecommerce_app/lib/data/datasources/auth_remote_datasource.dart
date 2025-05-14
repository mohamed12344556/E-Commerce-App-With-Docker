import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../services/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<dynamic> register(UserModel user, String password) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: user.toRegistrationJson(password),
    );

    return response; // يمكن أن يكون String أو Map
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    // إذا كان response ليس Map، نرميه كاستثناء
    if (response is! Map<String, dynamic>) {
      throw Exception('Invalid login response format');
    }

    return response;
  }

  Future<Map<String, dynamic>> updateProfile(
    String name,
    String phoneNumber,
  ) async {
    // الحصول على معرف المستخدم ورمز الوصول
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found. Please login again.');
    }

    print('Updating profile for user ID: $userId');
    print('Name: $name, Phone: $phoneNumber');

    // استخدام صيغة المسار الصحيحة
    final url = '${ApiConstants.updateUser}/$userId';
    print('Update profile URL: $url');

    // تجربة مع معلمات استعلام
    final response = await _apiClient.put(
      url,
      queryParameters: {'name': name, 'PhoneNum': phoneNumber},
    );

    print('Profile update response: $response');

    // تجربة بديلة إذا فشلت المحاولة الأولى
    if (response == null) {
      print('First attempt failed, trying alternative approach');

      // تجربة مع بيانات في الجسم
      final alternativeResponse = await _apiClient.put(
        url,
        data: {'name': name, 'PhoneNum': phoneNumber},
      );

      print('Alternative update response: $alternativeResponse');
    }

    // حفظ البيانات المحدثة
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phoneNumber);

    return {'success': true};
  }
}
