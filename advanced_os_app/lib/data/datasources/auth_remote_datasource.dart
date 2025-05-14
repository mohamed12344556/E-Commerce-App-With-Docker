import '../../services/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  
  AuthRemoteDataSource(this._apiClient);
  
  Future<Map<String, dynamic>> register(UserModel user, String password) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: user.toRegistrationJson(password),
    );
    
    return response;
  }
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    return response;
  }
  
  Future<Map<String, dynamic>> updateProfile(String name, String phoneNumber) async {
    final queryParams = {
      'name': name,
      'PhoneNum': phoneNumber,
    };
    
    final response = await _apiClient.put(
      ApiConstants.updateUser,
      data: queryParams,
    );
    
    return response;
  }
}
