import 'dart:async';

import 'package:flutter/services.dart';

typedef DetectPluggedCallback = Function(HeadsetChangedEvent payload);

enum HeadsetType { WIRED, WIRELESS }

enum HeadsetState {
  CONNECTED,
  DISCONNECTED,
}

enum HeadsetChangedEvent {
  WIRED_CONNECTED,
  WIRED_DISCONNECTED,
  WIRELESS_CONNECTED,
  WIRELESS_DISCONNECTED,
}

/*
The HeadsetDetector class allows you to listen to different headset status changes.
These status changes include plugging in and out of physical headset to your phone,
connecting, and disconnecting of bluetooth devices.

Usage: Instantiate a [HeadsetDetector] by using a factory constructor. Under the hood,
this constructor will always return a single instance if one has been instantiated before.
*/
class HeadsetDetector {
  static HeadsetDetector? _instance;

  final MethodChannel? _channel;

  DetectPluggedCallback? _detectPluggedCallback;

  HeadsetDetector.private(this._channel);

  factory HeadsetDetector() {
    if (_instance == null) {
      final methodChannel =
          const MethodChannel('flutter.moum/flutter_headset_detector');
      _instance = HeadsetDetector.private(methodChannel);
    }

    return _instance!;
  }

  //Reads asynchronously the current state of the headset with type [HeadsetState]
  Future<Map<HeadsetType, HeadsetState>> get getCurrentState async {
    final state = await _channel!.invokeMethod('getCurrentState');

    return {
      HeadsetType.WIRED:
          state[0] ? HeadsetState.CONNECTED : HeadsetState.DISCONNECTED,
      HeadsetType.WIRELESS:
          state[1] ? HeadsetState.CONNECTED : HeadsetState.DISCONNECTED,
    };
  }

  //Sets a callback that is called whenever a change in [HeadsetState] happens.
  //Callback function [onPlugged] must accept a [HeadsetState] parameter.
  void setListener(DetectPluggedCallback onPlugged) {
    _detectPluggedCallback = onPlugged;
    _channel!.setMethodCallHandler(_handleMethod);
  }

  // Removes the callback listener if it exists
  void removeListener() {
    _channel!.setMethodCallHandler(null);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    final callback = _detectPluggedCallback;
    if (callback == null) {
      return;
    }

    switch (call.method) {
      case 'wired_connected':
        return callback(HeadsetChangedEvent.WIRED_CONNECTED);
      case 'wired_disconnected':
        return callback(HeadsetChangedEvent.WIRED_DISCONNECTED);
      case 'wireless_connected':
        return callback(HeadsetChangedEvent.WIRELESS_CONNECTED);
      case 'wireless_disconnected':
        return callback(HeadsetChangedEvent.WIRELESS_DISCONNECTED);
    }
  }
}
