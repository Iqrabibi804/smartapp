import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Simple service to check internet connectivity.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Returns true if the device has any network connection (wifi, cellular, etc.).
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream that emits connectivity changes.
  Stream<ConnectivityResult> get onConnectivityChanged => _connectivity.onConnectivityChanged;
}
