part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  final bool isTablet;
  final double width;
  final double height;

  DeviceState(this.isTablet, this.width, this.height);
  @override
  List<Object> get props => [];
}

class InitialDeviceState extends DeviceState {
  InitialDeviceState() : super(false, DEVICE_WIDTH, DEVICE_HEIGHT);
}

// ignore: must_be_immutable
class FetchedDeviceState extends DeviceState {
  FetchedDeviceState(bool isTablet, double width, double height)
      : super(isTablet, width, height);
}
