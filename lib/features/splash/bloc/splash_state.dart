import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashSuccess extends SplashState {}

class SplashFailure extends SplashState {
  final String error;

  const SplashFailure(this.error);

  @override
  List<Object?> get props => [error];
}
