import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final String expiration;
  
  Authenticated({
    required this.token,
    required this.expiration,
  });
  
  @override
  List<Object?> get props => [token, expiration];
}

class AuthenticationFailed extends AuthState {
  final String message;
  
  AuthenticationFailed(this.message);
  
  @override
  List<Object?> get props => [message];
}

class RegistrationSuccess extends AuthState {}

class RegistrationFailed extends AuthState {
  final String message;
  
  RegistrationFailed(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProfileUpdateSuccess extends AuthState {}

class ProfileUpdateFailed extends AuthState {
  final String message;
  
  ProfileUpdateFailed(this.message);
  
  @override
  List<Object?> get props => [message];
}

class LoggedOut extends AuthState {}
