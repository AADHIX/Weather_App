import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (success && mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  void _fillDemoCredentials() {
    _emailController.text = 'demo@weather.com';
    _passwordController.text = 'password123';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo & Header
                    Center(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.wb_sunny_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to track real-time weather worldwide',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),

                    // Error Message Banner
                    Obx(() {
                      if (_authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _authController.errorMessage.value,
                                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ).animate().shake(duration: 300.ms);
                      }
                      return const SizedBox.shrink();
                    }),

                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 18),

                    // Password Field
                    Obx(() => AuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: !_authController.isPasswordVisible.value,
                          textInputAction: TextInputAction.done,
                          validator: Validators.validatePassword,
                          onFieldSubmitted: (_) => _handleLogin(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authController.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: _authController.togglePasswordVisibility,
                          ),
                        )).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 12),

                    // Remember Me Checkbox & Demo Helper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: _authController.rememberMe.value,
                                  onChanged: _authController.toggleRememberMe,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _fillDemoCredentials,
                          child: const Text(
                            'Use Demo Account',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 350.ms),
                    const SizedBox(height: 24),

                    // Login Button
                    Obx(() => AuthButton(
                          text: 'Sign In',
                          isLoading: _authController.isLoading.value,
                          icon: Icons.login_rounded,
                          onPressed: _handleLogin,
                        )).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Navigation to Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            _authController.errorMessage.value = '';
                            context.push(AppRoutes.register);
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 450.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
