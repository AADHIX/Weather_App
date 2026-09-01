import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../../modules/auth/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUserSession(UserModel user, {required bool rememberMe});
  Future<void> clearUserSession();
  Future<bool> getRememberMe();
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<UserModel?> authenticateUser({
    required String email,
    required String password,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<UserModel?> getCurrentUser() async {
    final rememberMe = _storageService.getBool(AppConstants.keyRememberMe) ?? false;
    if (!rememberMe) {
      // If remember me is false, session is transient
      final data = _storageService.getObject(AppConstants.keyUserSession);
      if (data == null) return null;
      return UserModel.fromJson(data);
    }
    final data = _storageService.getObject(AppConstants.keyUserSession);
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> saveUserSession(UserModel user, {required bool rememberMe}) async {
    await _storageService.setObject(AppConstants.keyUserSession, user.toJson());
    await _storageService.setBool(AppConstants.keyRememberMe, rememberMe);
  }

  @override
  Future<void> clearUserSession() async {
    await _storageService.remove(AppConstants.keyUserSession);
    await _storageService.remove(AppConstants.keyRememberMe);
  }

  @override
  Future<bool> getRememberMe() async {
    return _storageService.getBool(AppConstants.keyRememberMe) ?? false;
  }

  @override
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final users = _storageService.getObjectList(AppConstants.keyRegisteredUsers) ?? [];
    
    // Check if user already exists
    final exists = users.any(
      (u) => (u['email'] as String).toLowerCase() == email.trim().toLowerCase(),
    );
    if (exists) {
      throw Exception('An account with this email already exists.');
    }

    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'phone': phone,
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(newUser);
    return await _storageService.setObjectList(AppConstants.keyRegisteredUsers, users);
  }

  @override
  Future<UserModel?> authenticateUser({
    required String email,
    required String password,
  }) async {
    final users = _storageService.getObjectList(AppConstants.keyRegisteredUsers) ?? [];
    
    // Default demo account for instant testing if no users registered yet
    if (users.isEmpty) {
      final defaultUser = {
        'id': 'demo_user_1',
        'name': 'Weather Explorer',
        'email': 'demo@weather.com',
        'password': 'password123',
        'createdAt': DateTime.now().toIso8601String(),
      };
      users.add(defaultUser);
      await _storageService.setObjectList(AppConstants.keyRegisteredUsers, users);
    }

    final matched = users.firstWhere(
      (u) =>
          (u['email'] as String).toLowerCase() == email.trim().toLowerCase() &&
          u['password'] == password,
      orElse: () => {},
    );

    if (matched.isEmpty) {
      return null;
    }

    return UserModel.fromJson(matched);
  }
}
