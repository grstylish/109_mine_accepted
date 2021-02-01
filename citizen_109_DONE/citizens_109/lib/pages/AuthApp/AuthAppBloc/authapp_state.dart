import 'package:equatable/equatable.dart';

abstract class AuthAppState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthAppInitialState extends AuthAppState {}

class UnauthAppState extends AuthAppState {}

class LoadingAppAuthState extends AuthAppState {}

class AuthenticatedAppState extends AuthAppState {}

class FailureAppAuthState extends AuthAppState {
  final int error;
  FailureAppAuthState(this.error);
}
