import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(Authenticating());
    
    try {
      final response = await authRepository.login(
        event.email,
        event.password,
      );
      
      if (response.containsKey('token') && response.containsKey('expiration')) {
        final token = response['token'];
        final expiration = response['expiration'];
        
        // Save token and expiration
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('token_expiration', expiration);
        
        emit(Authenticated(token: token, expiration: expiration));
      } else {
        emit(AuthenticationFailed('Invalid login response. Please try again.'));
      }
    } catch (e) {
      emit(AuthenticationFailed(e.toString()));
    }
  }
  
  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    try {
      final success = await authRepository.updateProfile(
        event.name,
        event.phoneNumber,
      );
      
      if (success) {
        emit(ProfileUpdateSuccess());
        
        // Refresh auth status after profile update
        _checkAuthStatus();
      } else {
        emit(ProfileUpdateFailed('Profile update failed. Please try again.'));
      }
    } catch (e) {
      emit(ProfileUpdateFailed(e.toString()));
    }
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
