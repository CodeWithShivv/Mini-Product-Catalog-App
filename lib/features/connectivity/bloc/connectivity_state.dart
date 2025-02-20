import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityUpdated extends ConnectivityState {
  final bool isConnected;

  ConnectivityUpdated(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
