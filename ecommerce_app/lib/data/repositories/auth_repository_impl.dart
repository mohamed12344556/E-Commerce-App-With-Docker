import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  
  AuthRepositoryImpl(this._authRemoteDataSource);
  
  @override
  Future<bool> register(String username, String email, String password, String phoneNumber) async {
    try {
      final user = UserModel(
        userName: username,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      await _authRemoteDataSource.register(user, password);
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
  
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _authRemoteDataSource.login(email, password);
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
