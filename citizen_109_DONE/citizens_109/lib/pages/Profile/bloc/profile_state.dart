import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class LoadProfileState extends ProfileState {
  final ProfileInformation loadedprofileinformation;
  LoadProfileState({@required this.loadedprofileinformation})
      : assert(loadedprofileinformation != null);

  // @override
  // List<Object> get props => [loadedprofileinformation];
}

//Между виджетами push.named
class RequestSendedProfileState extends ProfileState {}

class FailureProfileState extends ProfileState {
  final String error;

  FailureProfileState(this.error);
}
