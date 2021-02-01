import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

abstract class ApplyEvent extends Equatable {
  const ApplyEvent();
  @override
  List<Object> get props => [];
}

class LoadImageEvent extends ApplyEvent {}

class LoadApplyCategories extends ApplyEvent {
  final int imageID;
  LoadApplyCategories(this.imageID);
}

class SendRequestEvent extends ApplyEvent {
  final int category;
  final int sub_category;
  final String address;
  final String description;
  final bool agreement;
  final List<File> image;
  final int group;

  SendRequestEvent({
    @required this.category,
    @required this.sub_category,
    @required this.address,
    @required this.description,
    @required this.agreement,
    @required this.group,
    @required this.image,
  });
}

///
///
///
///Для карты

abstract class MapControlEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLocationName extends MapControlEvent {
  final LatLng latLng;
  GetLocationName(this.latLng);
}
