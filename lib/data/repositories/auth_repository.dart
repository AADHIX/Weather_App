import '../../modules/auth/models/user_model.dart';
import '../datasources/auth_local_datasource.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUserSession(UserModel user, {required bool rememberMe});
  Future<void> logout();
  Future<bool> getRememberMe();
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<UserModel?> login({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<UserModel?> getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  @override
  Future<void> saveUserSession(UserModel user, {required bool rememberMe}) {
    return _localDataSource.saveUserSession(user, rememberMe: rememberMe);
  }

  @override
  Future<void> logout() {
    return _localDataSource.clearUserSession();
  }

  @override
  Future<bool> getRememberMe() {
    return _localDataSource.getRememberMe();
  }

  @override
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) {
    return _localDataSource.registerUser(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) {
    return _localDataSource.authenticateUser(
      email: email,
      password: password,
    );
  }
}
