import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mini_product_catalog_app/features/connectivity/bloc/connectivity_event.dart';
import 'package:mini_product_catalog_app/features/connectivity/bloc/connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<CheckConnectivity>((event, emit) async {
      emit(ConnectivityUpdated(await _checkInternetAccess()));
    });

    on<ConnectivityChanged>((event, emit) {
      emit(ConnectivityUpdated(event.isConnected));
    });

    _initConnectivityListener();
  }

  /// **Initialize connectivity listener**
  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) async {
        bool isConnected = await _checkInternetAccess();
        add(ConnectivityChanged(isConnected));
      },
    );
  }

  /// **Check internet access by pinging Google**
  Future<bool> _checkInternetAccess() async {
    try {
      if ((await _connectivity.checkConnectivity()) ==
          ConnectivityResult.none) {
        return false;
      }
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
