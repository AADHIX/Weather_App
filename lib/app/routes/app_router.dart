import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/weather/views/weather_home_view.dart';
import '../../modules/weather/views/weather_search_view.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthController authController) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutes.home,
      refreshListenable: authController.authChangeNotifier,
      redirect: (BuildContext context, GoRouterState state) {
        if (!authController.isInitialized.value) {
          return null;
        }

        final bool loggedIn = authController.isLoggedIn.value;
        final String location = state.matchedLocation;

        final bool isGoingToAuth =
            location == AppRoutes.login || location == AppRoutes.register;

        // If not logged in and not on auth pages, redirect to login
        if (!loggedIn && !isGoingToAuth) {
          return AppRoutes.login;
        }

        // If logged in and attempting to visit auth pages, redirect to home
        if (loggedIn && isGoingToAuth) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const WeatherHomeView(),
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const WeatherSearchView(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri.toString()}'),
        ),
      ),
    );
  }
}
