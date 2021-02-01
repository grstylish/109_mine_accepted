part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchDeviceEvent extends DeviceEvent {
  final bool isTablet;
  final double width;
  final double height;

  FetchDeviceEvent({
    @required this.isTablet,
    @required this.width,
    @required this.height,
  });
}
