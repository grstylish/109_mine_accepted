import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

//Для новостей
class LoadNotificationEvent extends NotificationEvent {}

// class LoadSendAgreementEvent extends NotificationEvent {}

// class LoadSendRejectEvent extends NotificationEvent {}

///
///
///

abstract class NotfActionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckNotfActionEvent extends NotfActionEvent {}

class ConfigNotfActionEvent extends NotfActionEvent {
  final bool value;
  ConfigNotfActionEvent(this.value);
}
