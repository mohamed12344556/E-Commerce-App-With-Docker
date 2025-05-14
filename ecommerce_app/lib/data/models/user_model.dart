import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String userName,
    required String email,
    required String phoneNumber,
  }) : super(
    userName: userName,
    email: email,
    phoneNumber: phoneNumber,
  );
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
  
  // For registration
  Map<String, dynamic> toRegistrationJson(String password) {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
  
  // For login
  Map<String, dynamic> toLoginJson(String password) {
    return {
      'email': email,
      'password': password,
    };
  }
  
  // For profile update
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': userName,
      'PhoneNum': phoneNumber,
    };
  }
}
