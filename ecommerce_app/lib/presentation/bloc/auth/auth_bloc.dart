import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);

    // Check if user is already logged in
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final expiration = prefs.getString('token_expiration');

    if (token != null && expiration != null) {
      // Check if token is still valid
      final expirationDate = DateTime.parse(expiration);
      if (expirationDate.isAfter(DateTime.now())) {
        emit(Authenticated(token: token, expiration: expiration));
      } else {
        // Token expired, clear and logout
        await _clearAuthData();
        emit(LoggedOut());
      }
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(Authenticating());

    try {
      final success = await authRepository.register(
        event.username,
        event.email,
        event.password,
        event.phoneNumber,
      );

      if (success) {
        emit(RegistrationSuccess());
      } else {
        emit(RegistrationFailed('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(RegistrationFailed(e.toString()));
    }
  }

  Future<String?> _findUserIdByEmail(String email, String token) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      print('Finding user ID for email: $email');

      // استخدام GetAllUsers لاسترجاع قائمة المستخدمين
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.getAllUsers}',
      );

      print('GetAllUsers response: ${response.data}');

      if (response.statusCode == 200 && response.data is List) {
        // البحث عن المستخدم بالبريد الإلكتروني
        for (var user in response.data) {
          if (user is Map<String, dynamic> &&
              user.containsKey('email') &&
              user['email'] == email) {
            String userId = user['id'];
            print('Found user ID: $userId');
            return userId;
          }
        }
      }

      return null;
    } catch (e) {
      print('Error finding user ID: $e');
      return null;
    }
  }

  // Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  //   emit(Authenticating());

  //   try {
  //     final response = await authRepository.login(event.email, event.password);

  //     if (response.containsKey('token') && response.containsKey('expiration')) {
  //       final token = response['token'];
  //       final expiration = response['expiration'];

  //       // استخراج معرف المستخدم
  //       String? userId;

  //       // 1. البحث في الاستجابة نفسها
  //       if (response.containsKey('id')) {
  //         userId = response['id'];
  //       }

  //       // 2. إذا لم يتم العثور عليه، حاول استخراجه من JWT
  //       if (userId == null && token is String) {
  //         try {
  //           final parts = token.split('.');
  //           if (parts.length == 3) {
  //             // فك تشفير الجزء الثاني من JWT (Payload)
  //             final payload = parts[1];
  //             final normalized = base64Url.normalize(payload);
  //             final decoded = utf8.decode(base64Url.decode(normalized));
  //             final payloadMap = json.decode(decoded) as Map<String, dynamic>;

  //             // JWT قد يحتوي على المعرف كـ 'nameid' أو 'sub' أو 'jti'
  //             if (payloadMap.containsKey('nameid')) {
  //               userId = payloadMap['nameid'];
  //             } else if (payloadMap.containsKey('sub')) {
  //               userId = payloadMap['sub'];
  //             } else if (payloadMap.containsKey('jti')) {
  //               userId = payloadMap['jti'];
  //             }
  //           }
  //         } catch (e) {
  //           print('Error parsing JWT: $e');
  //         }
  //       }

  //       // حفظ البيانات
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('auth_token', token);
  //       await prefs.setString('token_expiration', expiration);

  //       // حفظ معرف المستخدم إذا كان متاحًا
  //       if (userId != null) {
  //         await prefs.setString('user_id', userId);

  //         // محاولة جلب بيانات المستخدم
  //         try {
  //           final userData = await _fetchUserData(userId, token);
  //           if (userData != null) {
  //             await _saveUserData(userData);
  //           }
  //         } catch (e) {
  //           print('Error fetching user data: $e');
  //         }
  //       }

  //       // حفظ البريد الإلكتروني
  //       await prefs.setString('user_email', event.email);

  //       emit(Authenticated(token: token, expiration: expiration));
  //     } else {
  //       emit(AuthenticationFailed('Invalid login response. Please try again.'));
  //     }
  //   } catch (e) {
  //     emit(AuthenticationFailed(e.toString()));
  //   }
  // }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(Authenticating());

    try {
      final response = await authRepository.login(event.email, event.password);

      print('Login response: $response');

      if (response.containsKey('token') && response.containsKey('expiration')) {
        final token = response['token'];
        final expiration = response['expiration'];

        // حفظ البيانات الأساسية
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('token_expiration', expiration);
        await prefs.setString('user_email', event.email);

        // البحث عن معرف المستخدم الصحيح
        final userId = await _findUserIdByEmail(event.email, token);

        if (userId != null) {
          await prefs.setString('user_id', userId);
          print('Saved user ID: $userId');

          // جلب بيانات المستخدم
          await _fetchUserData(userId, token);
        } else {
          print('Could not find user ID for email: ${event.email}');
        }

        emit(Authenticated(token: token, expiration: expiration));
      } else {
        emit(AuthenticationFailed('Invalid login response. Please try again.'));
      }
    } catch (e) {
      emit(AuthenticationFailed(e.toString()));
    }
  }

  // دالة لجلب بيانات المستخدم بعد تسجيل الدخول
  Future<void> _fetchUserData(String userId, String token) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      print('Fetching user data for ID: $userId');

      // استخدام معلمة استعلام كما هو مطلوب في API
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.getUserDataById}',
        queryParameters: {'userId': userId},
      );

      print('User data response: ${response.data}');

      if (response.statusCode == 200) {
        final userData = response.data;

        // حفظ البيانات في SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        if (userData.containsKey('name')) {
          await prefs.setString('user_name', userData['name']);
          print('Saved name: ${userData['name']}');
        }

        if (userData.containsKey('phoneNumber')) {
          await prefs.setString('user_phone', userData['phoneNumber']);
          print('Saved phone: ${userData['phoneNumber']}');
        }

        if (userData.containsKey('email')) {
          await prefs.setString('user_email', userData['email']);
          print('Saved email: ${userData['email']}');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');

      // تجربة بديلة - استخدام المعرف مباشرة في المسار
      try {
        final dio = Dio();
        dio.options.headers['Authorization'] = 'Bearer $token';

        final response = await dio.get(
          '${ApiConstants.baseUrl}/api/Account/GetUserDataById?userId=$userId',
        );

        print('Alternative user data response: ${response.data}');

        // معالجة الاستجابة كما سبق
      } catch (e) {
        print('Alternative approach also failed: $e');
      }
    }
  }

  // Future<Map<String, dynamic>?> _fetchUserData(
  //   String userId,
  //   String token,
  // ) async {
  //   try {
  //     final dio = Dio();
  //     dio.options.headers['Authorization'] = 'Bearer $token';

  //     final response = await dio.get(
  //       '${ApiConstants.baseUrl}${ApiConstants.getUserDataById}',
  //       queryParameters: {'userId': userId},
  //     );

  //     if (response.statusCode == 200) {
  //       print('User data fetched: ${response.data}');
  //       return response.data;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching user data: $e');
  //     return null;
  //   }
  // }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    print('Saving user data: $userData');

    // حفظ البيانات الأساسية
    if (userData.containsKey('name')) {
      await prefs.setString('user_name', userData['name']);
      print('Saved name: ${userData['name']}');
    }

    if (userData.containsKey('phoneNumber')) {
      await prefs.setString('user_phone', userData['phoneNumber']);
      print('Saved phone: ${userData['phoneNumber']}');
    }

    if (userData.containsKey('email')) {
      await prefs.setString('user_email', userData['email']);
      print('Saved email: ${userData['email']}');
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print('Handling UpdateProfileEvent');
      print('Name: ${event.name}, Phone: ${event.phoneNumber}');

      final success = await authRepository.updateProfile(
        event.name,
        event.phoneNumber,
      );

      print('Update profile result: $success');

      if (success) {
        // تحديث بيانات المستخدم المحلية
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', event.name);
        await prefs.setString('user_phone', event.phoneNumber);

        emit(ProfileUpdateSuccess());
      } else {
        emit(ProfileUpdateFailed('Profile update failed. Please try again.'));
      }
    } catch (e) {
      print('Profile update error: $e');
      emit(ProfileUpdateFailed(e.toString()));
    }
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _clearAuthData();
    emit(LoggedOut());
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('token_expiration');
  }
}
