import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  ConnectivityService() {
    _initConnectivityListener();
  }

  /// Initializes a listener to track real-time connectivity changes
  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isConnected =
          results.any((result) => result != ConnectivityResult.none);
      _connectivityController.add(isConnected);
    });
  }

  /// Returns a stream to listen for connectivity changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Checks if the device is currently connected to the internet
  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Dispose the stream controller when not needed
  void dispose() {
    _connectivityController.close();
  }
}
