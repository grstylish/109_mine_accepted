import 'package:equatable/equatable.dart';

abstract class AuthAppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStartedAuthEvent extends AuthAppEvent {}

class WSConnectionErrorEvent extends AuthAppEvent {}

class AuthenticateAuthAppEvent extends AuthAppEvent {}

class LogoutAuthEvent extends AuthAppEvent {}
