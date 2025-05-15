// import 'package:advanced_os_app/core/constants/api_constants.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../config/app_routes.dart';
// import '../../bloc/auth/auth_bloc.dart';
// import '../../bloc/auth/auth_event.dart';
// import '../../bloc/auth/auth_state.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String? _username;
//   String? _email;
//   String? _phoneNumber;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // _fetchUserProfile();
//     _loadUserProfile();
//   }

//   void _loadUserProfile() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       final email = prefs.getString('user_email');

//       print('Initial profile data:');
//       print('Email: $email');
//       print('Saved username: ${prefs.getString('user_name')}');
//       print('Saved phone: ${prefs.getString('user_phone')}');

//       if (token != null && email != null) {
//         // الحصول على معرف المستخدم من التخزين المحلي
//         String? userId = prefs.getString('user_id');
//         print('Stored user ID: $userId');

//         // إذا لم يتم العثور على معرف المستخدم، ابحث عنه بالبريد الإلكتروني
//         if (userId == null) {
//           userId = await _findUserIdByEmail(email, token);
//           if (userId != null) {
//             await prefs.setString('user_id', userId);
//             print('Found and saved user ID: $userId');
//           }
//         }

//         if (userId != null) {
//           try {
//             // جلب بيانات المستخدم المحدثة من API
//             final dio = Dio();
//             dio.options.headers['Authorization'] = 'Bearer $token';

//             final url =
//                 '${ApiConstants.baseUrl}${ApiConstants.getUserDataById}';
//             print('Fetching user data from URL: $url with userId: $userId');

//             final response = await dio.get(
//               url,
//               queryParameters: {'userId': userId},
//             );

//             print('Profile API response: ${response.data}');
//             print('Response type: ${response.data.runtimeType}');

//             if (response.statusCode == 200) {
//               final userData = response.data;

//               // طباعة محتوى البيانات
//               if (userData is Map<String, dynamic>) {
//                 print('User data keys: ${userData.keys.toList()}');

//                 // التعامل مع أسماء الحقول المختلفة المحتملة
//                 String? name;
//                 String? phoneNumber;

//                 // البحث عن حقل الاسم
//                 if (userData.containsKey('name')) {
//                   name = userData['name'];
//                   print('Found name: $name');
//                 } else if (userData.containsKey('userName')) {
//                   name = userData['userName'];
//                   print('Found userName: $name');
//                 } else if (userData.containsKey('NameUsr')) {
//                   name = userData['NameUsr'];
//                   print('Found NameUsr: $name');
//                 }

//                 // البحث عن حقل رقم الهاتف
//                 if (userData.containsKey('phoneNumber')) {
//                   phoneNumber = userData['phoneNumber'];
//                   print('Found phoneNumber: $phoneNumber');
//                 } else if (userData.containsKey('PhoneNum')) {
//                   phoneNumber = userData['PhoneNum'];
//                   print('Found PhoneNum: $phoneNumber');
//                 } else if (userData.containsKey('phone')) {
//                   phoneNumber = userData['phone'];
//                   print('Found phone: $phoneNumber');
//                 }

//                 // حفظ البيانات إذا تم العثور عليها
//                 if (name != null) {
//                   await prefs.setString('user_name', name);
//                   print('Saved name to prefs: $name');
//                 }

//                 if (phoneNumber != null) {
//                   await prefs.setString('user_phone', phoneNumber);
//                   print('Saved phone to prefs: $phoneNumber');
//                 }

//                 if (userData.containsKey('email')) {
//                   await prefs.setString('user_email', userData['email']);
//                   print('Saved email to prefs: ${userData['email']}');
//                 }

//                 await _saveUserDataToPrefs(userData);
//               } else {
//                 print('userData is not a Map<String, dynamic>');
//               }
//             }
//           } catch (e) {
//             print('Error fetching profile from API: $e');
//             // المتابعة باستخدام البيانات المحلية
//           }
//         }
//       }

//       // تحميل البيانات المحدثة من SharedPreferences بعد محاولة التحديث
//       final updatedName = prefs.getString('user_name');
//       final updatedPhone = prefs.getString('user_phone');

//       print('Updated profile data after API call:');
//       print('Updated name from prefs: $updatedName');
//       print('Updated phone from prefs: $updatedPhone');

//       setState(() {
//         _username = updatedName ?? 'User';
//         _email = prefs.getString('user_email') ?? 'N/A';
//         _phoneNumber = updatedPhone ?? 'N/A';
//         _isLoading = false;
//       });

//       print('Final UI state:');
//       print('_username: $_username');
//       print('_email: $_email');
//       print('_phoneNumber: $_phoneNumber');
//     } catch (e) {
//       print('Error loading profile: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // دالة مساعدة للبحث عن معرف المستخدم بالبريد الإلكتروني
//   Future<String?> _findUserIdByEmail(String email, String token) async {
//     try {
//       final dio = Dio();
//       dio.options.headers['Authorization'] = 'Bearer $token';

//       print('Finding user ID for email: $email');

//       final url = '${ApiConstants.baseUrl}${ApiConstants.getAllUsers}';
//       print('GetAllUsers URL: $url');

//       final response = await dio.get(url);

//       print('GetAllUsers response status: ${response.statusCode}');
//       print('GetAllUsers response type: ${response.data.runtimeType}');

//       if (response.data is List) {
//         print('Number of users: ${response.data.length}');

//         for (var user in response.data) {
//           print('User data: $user');

//           if (user is Map<String, dynamic>) {
//             print('User keys: ${user.keys.toList()}');

//             String? userEmail;

//             // البحث عن حقل البريد الإلكتروني
//             if (user.containsKey('email')) {
//               userEmail = user['email'];
//             } else if (user.containsKey('Email')) {
//               userEmail = user['Email'];
//             }

//             print('Current user email: $userEmail, searching for: $email');

//             if (userEmail == email) {
//               // البحث عن حقل المعرف
//               if (user.containsKey('id')) {
//                 String userId = user['id'];
//                 print('Found matching user with ID: $userId');
//                 return userId;
//               } else if (user.containsKey('Id')) {
//                 String userId = user['Id'];
//                 print('Found matching user with ID (capital): $userId');
//                 return userId;
//               }
//             }
//           }
//         }

//         print('No matching user found');
//       } else {
//         print('GetAllUsers response is not a list: ${response.data}');
//       }

//       return null;
//     } catch (e) {
//       print('Error finding user ID: $e');
//       return null;
//     }
//   }

//   Future<void> _saveUserDataToPrefs(Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();

//     print('Saving user data to prefs: $userData');

//     // أسماء الحقول المحتملة للاسم
//     final nameKeys = ['name', 'userName', 'NameUsr', 'Name'];
//     for (final key in nameKeys) {
//       if (userData.containsKey(key) && userData[key] != null) {
//         final name = userData[key].toString();
//         if (name.isNotEmpty) {
//           await prefs.setString('user_name', name);
//           print('Saved name: $name');
//           break;
//         }
//       }
//     }

//     // أسماء الحقول المحتملة لرقم الهاتف
//     final phoneKeys = ['phoneNumber', 'PhoneNum', 'phone', 'Phone'];
//     for (final key in phoneKeys) {
//       if (userData.containsKey(key) && userData[key] != null) {
//         final phone = userData[key].toString();
//         if (phone.isNotEmpty) {
//           await prefs.setString('user_phone', phone);
//           print('Saved phone: $phone');
//           break;
//         }
//       }
//     }

//     // أسماء الحقول المحتملة للبريد الإلكتروني
//     final emailKeys = ['email', 'Email'];
//     for (final key in emailKeys) {
//       if (userData.containsKey(key) && userData[key] != null) {
//         final email = userData[key].toString();
//         if (email.isNotEmpty) {
//           await prefs.setString('user_email', email);
//           print('Saved email: $email');
//           break;
//         }
//       }
//     }

//     // أسماء الحقول المحتملة للمعرف
//     final idKeys = ['id', 'Id', 'ID'];
//     for (final key in idKeys) {
//       if (userData.containsKey(key) && userData[key] != null) {
//         final id = userData[key].toString();
//         if (id.isNotEmpty) {
//           await prefs.setString('user_id', id);
//           print('Saved ID: $id');
//           break;
//         }
//       }
//     }
//   }

//   void _logout() {
//     context.read<AuthBloc>().add(LogoutEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is LoggedOut) {
//             Navigator.pushReplacementNamed(context, AppRoutes.login);
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile header
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Theme.of(context).primaryColor,
//                       child: Icon(Icons.person, size: 50, color: Colors.white),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       _username ?? 'User',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _email ?? 'email@example.com',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         color: Theme.of(context).textTheme.bodySmall?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Profile info section
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Personal Information',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       const SizedBox(height: 16),

//                       // Username
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.person_outline,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Username',
//                                   style: Theme.of(context).textTheme.bodySmall,
//                                 ),
//                                 Text(
//                                   _username ?? 'N/A',
//                                   style:
//                                       Theme.of(context).textTheme.titleMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 32),

//                       // Email
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.email_outlined,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Email',
//                                   style: Theme.of(context).textTheme.bodySmall,
//                                 ),
//                                 Text(
//                                   _email ?? 'N/A',
//                                   style:
//                                       Theme.of(context).textTheme.titleMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 32),

//                       // Phone
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.phone_outlined,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Phone',
//                                   style: Theme.of(context).textTheme.bodySmall,
//                                 ),
//                                 Text(
//                                   _phoneNumber ?? 'N/A',
//                                   style:
//                                       Theme.of(context).textTheme.titleMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Edit profile button
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.editProfile);
//                   },
//                   icon: Icon(Icons.edit),
//                   label: Text('Edit Profile'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:advanced_os_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_routes.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _email;
  String? _phoneNumber;
  bool _isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // New method to handle refreshing profile data
  Future<void> _refreshProfile() async {
    // Clear existing data to make refresh more noticeable
    setState(() {
      _isLoading = true;
    });

    // Force a full reload of user profile
    await _loadUserProfile(forceRefresh: true);

    return Future.delayed(
      Duration(milliseconds: 500),
    ); // Small delay for better UX
  }

  Future<void> _loadUserProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('user_email');

      print('Initial profile data:');
      print('Email: $email');
      print('Saved username: ${prefs.getString('user_name')}');
      print('Saved phone: ${prefs.getString('user_phone')}');

      if (token != null && email != null) {
        // الحصول على معرف المستخدم من التخزين المحلي
        String? userId = prefs.getString('user_id');
        print('Stored user ID: $userId');

        // إذا لم يتم العثور على معرف المستخدم، ابحث عنه بالبريد الإلكتروني
        if (userId == null || forceRefresh) {
          userId = await _findUserIdByEmail(email, token);
          if (userId != null) {
            await prefs.setString('user_id', userId);
            print('Found and saved user ID: $userId');
          }
        }

        if (userId != null) {
          try {
            // جلب بيانات المستخدم المحدثة من API
            final dio = Dio();
            dio.options.headers['Authorization'] = 'Bearer $token';

            final url =
                '${ApiConstants.baseUrl}${ApiConstants.getUserDataById}';
            print('Fetching user data from URL: $url with userId: $userId');

            final response = await dio.get(
              url,
              queryParameters: {'userId': userId},
            );

            print('Profile API response: ${response.data}');
            print('Response type: ${response.data.runtimeType}');

            if (response.statusCode == 200) {
              final userData = response.data;

              // طباعة محتوى البيانات
              if (userData is Map<String, dynamic>) {
                print('User data keys: ${userData.keys.toList()}');

                // التعامل مع أسماء الحقول المختلفة المحتملة
                String? name;
                String? phoneNumber;

                // البحث عن حقل الاسم
                if (userData.containsKey('name')) {
                  name = userData['name'];
                  print('Found name: $name');
                } else if (userData.containsKey('userName')) {
                  name = userData['userName'];
                  print('Found userName: $name');
                } else if (userData.containsKey('NameUsr')) {
                  name = userData['NameUsr'];
                  print('Found NameUsr: $name');
                }

                // البحث عن حقل رقم الهاتف
                if (userData.containsKey('phoneNumber')) {
                  phoneNumber = userData['phoneNumber'];
                  print('Found phoneNumber: $phoneNumber');
                } else if (userData.containsKey('PhoneNum')) {
                  phoneNumber = userData['PhoneNum'];
                  print('Found PhoneNum: $phoneNumber');
                } else if (userData.containsKey('phone')) {
                  phoneNumber = userData['phone'];
                  print('Found phone: $phoneNumber');
                }

                // حفظ البيانات إذا تم العثور عليها
                if (name != null) {
                  await prefs.setString('user_name', name);
                  print('Saved name to prefs: $name');
                }

                if (phoneNumber != null) {
                  await prefs.setString('user_phone', phoneNumber);
                  print('Saved phone to prefs: $phoneNumber');
                }

                if (userData.containsKey('email')) {
                  await prefs.setString('user_email', userData['email']);
                  print('Saved email to prefs: ${userData['email']}');
                }

                await _saveUserDataToPrefs(userData);
              } else {
                print('userData is not a Map<String, dynamic>');
              }
            }
          } catch (e) {
            print('Error fetching profile from API: $e');
            // المتابعة باستخدام البيانات المحلية
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Could not refresh profile data. Please try again.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }

      // تحميل البيانات المحدثة من SharedPreferences بعد محاولة التحديث
      final updatedName = prefs.getString('user_name');
      final updatedPhone = prefs.getString('user_phone');

      print('Updated profile data after API call:');
      print('Updated name from prefs: $updatedName');
      print('Updated phone from prefs: $updatedPhone');

      setState(() {
        _username = updatedName ?? 'User';
        _email = prefs.getString('user_email') ?? 'N/A';
        _phoneNumber = updatedPhone ?? 'N/A';
        _isLoading = false;
      });

      print('Final UI state:');
      print('_username: $_username');
      print('_email: $_email');
      print('_phoneNumber: $_phoneNumber');

      if (forceRefresh) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile data refreshed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoading = false;
      });

      if (forceRefresh) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh profile. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // دالة مساعدة للبحث عن معرف المستخدم بالبريد الإلكتروني
  Future<String?> _findUserIdByEmail(String email, String token) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      print('Finding user ID for email: $email');

      final url = '${ApiConstants.baseUrl}${ApiConstants.getAllUsers}';
      print('GetAllUsers URL: $url');

      final response = await dio.get(url);

      print('GetAllUsers response status: ${response.statusCode}');
      print('GetAllUsers response type: ${response.data.runtimeType}');

      if (response.data is List) {
        print('Number of users: ${response.data.length}');

        for (var user in response.data) {
          print('User data: $user');

          if (user is Map<String, dynamic>) {
            print('User keys: ${user.keys.toList()}');

            String? userEmail;

            // البحث عن حقل البريد الإلكتروني
            if (user.containsKey('email')) {
              userEmail = user['email'];
            } else if (user.containsKey('Email')) {
              userEmail = user['Email'];
            }

            print('Current user email: $userEmail, searching for: $email');

            if (userEmail == email) {
              // البحث عن حقل المعرف
              if (user.containsKey('id')) {
                String userId = user['id'];
                print('Found matching user with ID: $userId');
                return userId;
              } else if (user.containsKey('Id')) {
                String userId = user['Id'];
                print('Found matching user with ID (capital): $userId');
                return userId;
              }
            }
          }
        }

        print('No matching user found');
      } else {
        print('GetAllUsers response is not a list: ${response.data}');
      }

      return null;
    } catch (e) {
      print('Error finding user ID: $e');
      return null;
    }
  }

  Future<void> _saveUserDataToPrefs(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    print('Saving user data to prefs: $userData');

    // أسماء الحقول المحتملة للاسم
    final nameKeys = ['name', 'userName', 'NameUsr', 'Name'];
    for (final key in nameKeys) {
      if (userData.containsKey(key) && userData[key] != null) {
        final name = userData[key].toString();
        if (name.isNotEmpty) {
          await prefs.setString('user_name', name);
          print('Saved name: $name');
          break;
        }
      }
    }

    // أسماء الحقول المحتملة لرقم الهاتف
    final phoneKeys = ['phoneNumber', 'PhoneNum', 'phone', 'Phone'];
    for (final key in phoneKeys) {
      if (userData.containsKey(key) && userData[key] != null) {
        final phone = userData[key].toString();
        if (phone.isNotEmpty) {
          await prefs.setString('user_phone', phone);
          print('Saved phone: $phone');
          break;
        }
      }
    }

    // أسماء الحقول المحتملة للبريد الإلكتروني
    final emailKeys = ['email', 'Email'];
    for (final key in emailKeys) {
      if (userData.containsKey(key) && userData[key] != null) {
        final email = userData[key].toString();
        if (email.isNotEmpty) {
          await prefs.setString('user_email', email);
          print('Saved email: $email');
          break;
        }
      }
    }

    // أسماء الحقول المحتملة للمعرف
    final idKeys = ['id', 'Id', 'ID'];
    for (final key in idKeys) {
      if (userData.containsKey(key) && userData[key] != null) {
        final id = userData[key].toString();
        if (id.isNotEmpty) {
          await prefs.setString('user_id', id);
          print('Saved ID: $id');
          break;
        }
      }
    }
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          // Manual refresh button in app bar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshKey.currentState?.show(),
            tooltip: 'Refresh Profile',
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }

          // Refresh profile when update is successful
          if (state is ProfileUpdateSuccess) {
            _refreshKey.currentState?.show();
          }
        },
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refreshProfile,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          child:
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    physics:
                        AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile header
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _username ?? 'User',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _email ?? 'email@example.com',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Profile info section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),

                                // Username
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Username',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                          Text(
                                            _username ?? 'N/A',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 32),

                                // Email
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                          Text(
                                            _email ?? 'N/A',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 32),

                                // Phone
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Phone',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                          Text(
                                            _phoneNumber ?? 'N/A',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Edit profile button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editProfile,
                              ).then((_) => _refreshKey.currentState?.show());
                            },
                            icon: Icon(Icons.edit),
                            label: Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                        // Help text
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Center(
                            child: Text(
                              'Pull down to refresh profile data',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
