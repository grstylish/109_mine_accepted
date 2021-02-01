import 'package:citizens01/pages/Apply/models/apply_categories.dart';
import 'package:citizens01/pages/Apply/models/apply_images.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ApplyState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialApplyState extends ApplyState {}

class LoadingApplyState extends ApplyState {}

class LoadImageState extends ApplyState {
  final List<ApplyImages> loadapplyimages;
  LoadImageState({@required this.loadapplyimages})
      : assert(loadapplyimages != null);
}

class LoadCategoriesState extends ApplyState {
  final List<ApplyCategories> loadapplycategories;
  LoadCategoriesState({@required this.loadapplycategories})
      : assert(loadapplycategories != null);
}

class LoadSendRequest extends ApplyState {}

class FailureApplyState extends ApplyState {
  final String error;

  FailureApplyState(this.error);
}

//Между виджетами push.named
class RequestSendedApplyState extends ApplyState {}

///
///
///
/// Для карты

abstract class MapControlState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMapState extends MapControlState {}

class LoadingMapState extends MapControlState {}

class FetchedMapState extends MapControlState {
  final String name;
  FetchedMapState(this.name);
}
