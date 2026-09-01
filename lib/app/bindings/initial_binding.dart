import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/weather_local_datasource.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/weather_repository.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/weather/controllers/weather_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    final storageService = Get.find<StorageService>();
    final connectivityService = Get.find<ConnectivityService>();

    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);

    // Auth Data Sources & Repositories
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(storageService),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthLocalDataSource>()),
      fenix: true,
    );

    // Weather Data Sources & Repositories
    Get.lazyPut<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(Get.find<ApiService>(), storageService),
      fenix: true,
    );
    Get.lazyPut<WeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(storageService),
      fenix: true,
    );
    Get.lazyPut<WeatherRepository>(
      () => WeatherRepositoryImpl(
        Get.find<WeatherRemoteDataSource>(),
        Get.find<WeatherLocalDataSource>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.put<AuthController>(
      AuthController(Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.put<WeatherController>(
      WeatherController(
        weatherRepository: Get.find<WeatherRepository>(),
        locationService: Get.find<LocationService>(),
        connectivityService: connectivityService,
        storageService: storageService,
      ),
      permanent: true,
    );
  }
}
