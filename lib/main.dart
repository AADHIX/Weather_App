import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/utils/app_logger.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/weather/controllers/weather_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: '.env');
    AppLogger.success('.env loaded successfully', 'Main');
  } catch (e) {
    AppLogger.warning('Could not load .env file; using fallback constants: $e', 'Main');
  }

  // Initialize Core Services
  await Get.putAsync<StorageService>(() => StorageService().init(), permanent: true);
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init(), permanent: true);

  // Initialize Dependencies & Controllers
  InitialBinding().dependencies();

  runApp(const WeatherWiseApp());
}

class WeatherWiseApp extends StatefulWidget {
  const WeatherWiseApp({super.key});

  @override
  State<WeatherWiseApp> createState() => _WeatherWiseAppState();
}

class _WeatherWiseAppState extends State<WeatherWiseApp> {
  late final AuthController _authController;
  late final WeatherController _weatherController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _weatherController = Get.find<WeatherController>();
    _router = AppRouter.createRouter(_authController);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _weatherController.isDarkMode.value;

      return MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        routerConfig: _router,
      );
    });
  }
}
