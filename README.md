# Flutter Headset Detector Plugin

A Flutter plugin to get a headset event.

*This is a clone of [headset_connection_event](https://github.com/themobilecoder/headset_connection_event), but seperated wired and wireless event.*


## Current Status

| Platform    | Physical Headset | Bluetooth |
| ----------- | ---------------- | --------- |
| iOS         | ✅               | ✅        |
| Android     | ✅               | ✅        |


## Usage
To use this plugin, add `flutter_headset_detector` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
    // Import package
    import 'package:flutter_headset_detector/flutter_headset_detector.dart';

    // Instantiate it
    final headsetDetector = HeadsetDetector();
    Map<HeadsetType, HeadsetState> headsetState = {
      HeadsetType.WIRED: HeadsetState.DISCONNECTED,
      HeadsetType.WIRELESS: HeadsetState.DISCONNECTED,
    };

    /// if headset is plugged
  headsetDetector.getCurrentState.then((_val){
      headsetState = _val;
      setState(() {
      });
    });

    /// Detect the moment headset is plugged or unplugged
    headsetDetector.setListener((_val) {
      switch (_val) {
        case HeadsetChangedEvent.WIRED_CONNECTED:
          headsetState[HeadsetType.WIRED] = HeadsetState.CONNECTED;
          break;
        case HeadsetChangedEvent.WIRED_DISCONNECTED:
          headsetState[HeadsetType.WIRED] = HeadsetState.DISCONNECTED;
          break;
        case HeadsetChangedEvent.WIRELESS_CONNECTED:
          headsetState[HeadsetType.WIRELESS] = HeadsetState.CONNECTED;
          break;
        case HeadsetChangedEvent.WIRELESS_DISCONNECTED:
          headsetState[HeadsetType.WIRELESS] = HeadsetState.DISCONNECTED;
          break;
      }
      setState(() {
      });
    });
```


## Screenshot
* There are no connected headphones:
![Alt text](screenshot/both_not_connected.jpeg?raw=true "No connected")

* There are wired connected headphones:
![Alt text](screenshot/wired_connected.jpeg?raw=true "Wired connected")

* There are Bluetooth connected headphones:
![Alt text](screenshot/wireless_connected.jpeg?raw=true "Bluetooth connected")

* All types are connected:
![Alt text](screenshot/all_connected.jpeg?raw=true "All connected")
