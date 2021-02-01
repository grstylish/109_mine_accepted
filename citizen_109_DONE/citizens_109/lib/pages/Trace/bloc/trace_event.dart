import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TraceEvent extends Equatable {
  const TraceEvent();
  @override
  List<Object> get props => [];
}

//Для  активных заявок
class LoadTraceNameEvent extends TraceEvent {}

//Для поиска по номеру
class LoadSearchTraceNameEvent extends TraceEvent {
  final String track_number;
  LoadSearchTraceNameEvent(this.track_number);
}

//Для отправки оценки
class LoadSendEvaluationEvent extends TraceEvent {
  final int rating;
  final String comment;
  final int track_number;

  LoadSendEvaluationEvent({
    @required this.rating,
    @required this.comment,
    @required this.track_number,
  });
}
