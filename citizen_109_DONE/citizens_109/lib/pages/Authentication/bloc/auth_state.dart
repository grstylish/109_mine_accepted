import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

// Состояние когда только включилась
class AuthInitial extends AuthState {}

class UnAuthState extends AuthState {}

// Состояние в загрузке
class LoadingAuthState extends AuthState {}

// Состояние в загружено
class LoadedAuthState extends AuthState {}

// Состояние ошибка при загрузке
// class FailureAuthState extends AuthState {
//   final int error;
//   FailureAuthState(this.error);
// }

// Состояние ошибка при получении чего либо
class FailureLoginState extends AuthState {
  final String error;
  FailureLoginState(this.error);
}
