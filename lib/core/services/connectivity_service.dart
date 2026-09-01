import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../utils/app_logger.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isConnected = true.obs;

  Future<ConnectivityService> init() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      AppLogger.error('Failed to check initial connectivity', e, null, 'Connectivity');
      isConnected.value = true;
    }

    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    AppLogger.info('ConnectivityService initialized', 'Connectivity');
    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final connected = results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
    
    isConnected.value = connected;
    AppLogger.info(
      'Network status changed: ${connected ? "Online" : "Offline"} ($results)',
      'Connectivity',
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
