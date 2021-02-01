import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class TraceState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceState extends TraceState {}

class LoadingTraceState extends TraceState {}

class LoadActiveTraceNameState extends TraceState {
  final List<ActiveTraceName> loadedactivetracename;
  LoadActiveTraceNameState({
    @required this.loadedactivetracename,
  });
  // @override
  // List<Object> get props => [loadedactivetracename];
}

class LoadSearchTraceNameState extends TraceState {
  final List<SearchTraceName> loadedsearchtracename;
  LoadSearchTraceNameState({@required this.loadedsearchtracename});
}
// @override
// List<Object> get props => [loadedsearchtracename];

class LoadSendRequestState extends TraceState {}

class FailureTraceState extends TraceState {
  final String error;
  FailureTraceState(this.error);
}

//Когда у нас ничего не выводит
class EmptyTraceState extends TraceState {}
