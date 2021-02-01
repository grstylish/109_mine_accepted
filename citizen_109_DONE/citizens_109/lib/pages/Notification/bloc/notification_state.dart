import 'package:citizens01/pages/Notification/models/notification_news.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialNotificationState extends NotificationState {}

class LoadingNotificationState extends NotificationState {}

//Когда загружена новость
class LoadedNotificationState extends NotificationState {
  final List<NotificationNews> loadnotificationnews;
  LoadedNotificationState({@required this.loadnotificationnews});
}

// class LoadConfirmNotificationState extends NotificationState {}

// class LoadRejectNotificationState extends NotificationState {}

class FailureNotificationState extends NotificationState {
  final String error;
  FailureNotificationState(this.error);
}

///
///
///

abstract class NotfActionState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotfActionInitial extends NotfActionState {}

class CheckedNotfActionState extends NotfActionState {
  final bool value;
  CheckedNotfActionState(this.value);
}
