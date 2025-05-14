import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  
  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [username, email, password, phoneNumber];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  LoginEvent({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String phoneNumber;
  
  UpdateProfileEvent({
    required this.name,
    required this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [name, phoneNumber];
}

class LogoutEvent extends AuthEvent {}
