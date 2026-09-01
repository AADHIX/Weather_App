import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _authController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (success && mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 6),
                    Text(
                      'Join WeatherWise to get tailored weather forecasts',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 28),

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

                    // Name Field
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      prefixIcon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      validator: Validators.validateName,
                    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 16),

                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 16),

                    // Password Field
                    Obx(() => AuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: !_authController.isPasswordVisible.value,
                          validator: Validators.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authController.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: _authController.togglePasswordVisibility,
                          ),
                        )).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    Obx(() => AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_clock_outlined,
                          obscureText: !_authController.isConfirmPasswordVisible.value,
                          textInputAction: TextInputAction.done,
                          validator: (val) => Validators.validateConfirmPassword(
                            val,
                            _passwordController.text,
                          ),
                          onFieldSubmitted: (_) => _handleRegister(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authController.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: _authController.toggleConfirmPasswordVisibility,
                          ),
                        )).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 28),

                    // Register Button
                    Obx(() => AuthButton(
                          text: 'Sign Up',
                          isLoading: _authController.isLoading.value,
                          icon: Icons.person_add_alt_1_rounded,
                          onPressed: _handleRegister,
                        )).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Already have an account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
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
