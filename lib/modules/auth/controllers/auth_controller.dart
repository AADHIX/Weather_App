import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;
  final RxBool rememberMe = true.obs;
  final RxString errorMessage = ''.obs;

  // Password visibility states
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  // GoRouter Refresh Listenable
  final ValueNotifier<bool> authChangeNotifier = ValueNotifier<bool>(false);

  void _notifyRouter() {
    authChangeNotifier.value = !authChangeNotifier.value;
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      isLoading.value = true;
      final savedRememberMe = await _authRepository.getRememberMe();
      rememberMe.value = savedRememberMe;

      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        AppLogger.success('User session restored: ${user.email}', 'Auth');
      } else {
        currentUser.value = null;
        isLoggedIn.value = false;
        AppLogger.info('No active user session', 'Auth');
      }
    } catch (e) {
      AppLogger.error('Error restoring auth status', e, null, 'Auth');
      isLoggedIn.value = false;
      currentUser.value = null;
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
      _notifyRouter();
    }
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<bool> login(String email, String password) async {
    errorMessage.value = '';
    isLoading.value = true;
    try {
      final user = await _authRepository.login(
        email: email.trim(),
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        await _authRepository.saveUserSession(user, rememberMe: rememberMe.value);
        AppLogger.success('Login successful: ${user.email}', 'Auth');
        _notifyRouter();
        return true;
      } else {
        errorMessage.value = 'Invalid email or password. Please try again.';
        return false;
      }
    } catch (e) {
      AppLogger.error('Login error', e, null, 'Auth');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    errorMessage.value = '';
    isLoading.value = true;
    try {
      final registered = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      if (registered) {
        final user = await _authRepository.login(
          email: email.trim(),
          password: password,
        );
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
          await _authRepository.saveUserSession(user, rememberMe: rememberMe.value);
          AppLogger.success('Registration and login successful: ${user.email}', 'Auth');
          _notifyRouter();
          return true;
        }
      }
      return false;
    } catch (e) {
      AppLogger.error('Registration error', e, null, 'Auth');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      AppLogger.info('User logged out', 'Auth');
      _notifyRouter();
    } catch (e) {
      AppLogger.error('Logout error', e, null, 'Auth');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    authChangeNotifier.dispose();
    super.onClose();
  }
}
