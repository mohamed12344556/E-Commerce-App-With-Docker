import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> register(String username, String email, String password, String phoneNumber);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<bool> updateProfile(String name, String phoneNumber);
}
