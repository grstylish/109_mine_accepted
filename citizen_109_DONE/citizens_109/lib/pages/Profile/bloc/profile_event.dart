import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

//Для Update Username, Lastname
class LoadUpdateProfileEvent extends ProfileEvent {
  String lastname;
  String username;

  LoadUpdateProfileEvent({@required this.lastname, @required this.username});
}

class LoadUpdateEmailEvent extends ProfileEvent {
  String email;
  LoadUpdateEmailEvent({@required this.email});
}
