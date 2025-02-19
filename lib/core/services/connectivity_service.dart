import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityService() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() async {
    bool initialConnection = await isConnected();
    _connectivityController.add(initialConnection);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      bool isConnected =
          results.any((result) => result != ConnectivityResult.none);
      _connectivityController.add(isConnected);
    });
  }

  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false; // No network interfaces detected
      }

      // Perform an actual network request (Google DNS)
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false; // No internet
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
