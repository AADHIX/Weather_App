import 'package:geolocator/geolocator.dart';
import '../utils/app_logger.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String? error;
  final bool isSuccess;

  LocationResult.success(this.latitude, this.longitude)
      : error = null,
        isSuccess = true;

  LocationResult.failure(this.error)
      : latitude = 0,
        longitude = 0,
        isSuccess = false;
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.warning('Location services are disabled', 'Location');
        return LocationResult.failure(
          'Location services are disabled on your device. Please enable GPS in settings.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.warning('Location permission was denied', 'Location');
          return LocationResult.failure(
            'Location permissions are denied. Search by city name instead.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppLogger.warning('Location permission permanently denied', 'Location');
        return LocationResult.failure(
          'Location permissions are permanently denied. Please enable them in app settings or search by city.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      AppLogger.success(
        'Fetched location: lat=${position.latitude}, lon=${position.longitude}',
        'Location',
      );
      return LocationResult.success(position.latitude, position.longitude);
    } catch (e) {
      AppLogger.error('Failed to get current location', e, null, 'Location');
      return LocationResult.failure(
        'Unable to retrieve current location: ${e.toString()}',
      );
    }
  }
}
