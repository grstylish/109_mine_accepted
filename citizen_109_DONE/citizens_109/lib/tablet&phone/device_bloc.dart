import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:citizens01/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(InitialDeviceState());

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    if (event is FetchDeviceEvent) {
      yield InitialDeviceState();
      yield FetchedDeviceState(event.isTablet, event.width, event.height);
    }
  }
}
