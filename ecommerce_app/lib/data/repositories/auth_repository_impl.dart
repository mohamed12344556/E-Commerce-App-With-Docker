import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<bool> register(
    String username,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      final user = UserModel(
        userName: username,
        email: email,
        phoneNumber: phoneNumber,
      );

      final response = await _authRemoteDataSource.register(user, password);

      // التحقق من نوع الاستجابة - قد تكون String أو Map
      if (response is String && response == "Success") {
        return true;
      } else if (response is Map<String, dynamic> &&
          response.containsKey('success')) {
        return true;
      }

      // إذا وصلنا إلى هنا، فقد حدث خطأ ما
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // @override
  // Future<Map<String, dynamic>> login(String email, String password) async {
  //   try {
  //     final response = await _authRemoteDataSource.login(email, password);
  //     return response;
  //   } catch (e) {
  //     print('Login error: $e');
  //     rethrow;
  //   }
  // }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _authRemoteDataSource.login(email, password);

      // إذا كانت الاستجابة لا تحتوي على معرف المستخدم، حاول جلبه
      if (response.containsKey('token') && !response.containsKey('id')) {
        // هذا سيعتمد على كيفية استخراج المعرف من التوكن
        // يمكن إضافة منطق لاستخراج المعرف هنا إذا لزم الأمر
      }

      return response;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> updateProfile(String name, String phoneNumber) async {
    try {
      await _authRemoteDataSource.updateProfile(name, phoneNumber);
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}
