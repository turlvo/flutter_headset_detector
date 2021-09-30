import 'package:flutter/material.dart';
import 'package:flutter_headset_detector/flutter_headset_detector.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _headsetDetector = HeadsetDetector();
  Map<HeadsetType, HeadsetState> _headsetState = {
    HeadsetType.WIRED: HeadsetState.DISCONNECTED,
    HeadsetType.WIRELESS: HeadsetState.DISCONNECTED,
  };

  @override
  void initState() {
    super.initState();

    /// if headset is plugged
    _headsetDetector.getCurrentState.then((_val) {
      setState(() {
        _headsetState = _val;
      });
    });

    /// Detect the moment headset is plugged or unplugged
    _headsetDetector.setListener((_val) {
      switch (_val) {
        case HeadsetChangedEvent.WIRED_CONNECTED:
          _headsetState[HeadsetType.WIRED] = HeadsetState.CONNECTED;
          break;
        case HeadsetChangedEvent.WIRED_DISCONNECTED:
          _headsetState[HeadsetType.WIRED] = HeadsetState.DISCONNECTED;
          break;
        case HeadsetChangedEvent.WIRELESS_CONNECTED:
          _headsetState[HeadsetType.WIRELESS] = HeadsetState.CONNECTED;
          break;
        case HeadsetChangedEvent.WIRELESS_DISCONNECTED:
          _headsetState[HeadsetType.WIRELESS] = HeadsetState.DISCONNECTED;
          break;
      }
      setState(() {});
    });
  }

  Color _mapStateToColor(HeadsetState? state) {
    switch (state) {
      case HeadsetState.CONNECTED:
        return Colors.green;
      case HeadsetState.DISCONNECTED:
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  String _mapStateToText(HeadsetState? state) {
    switch (state) {
      case HeadsetState.CONNECTED:
        return 'Connected';
      case HeadsetState.DISCONNECTED:
        return 'Disconnected';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Current wired connection state'),
              subtitle: Text(_mapStateToText(_headsetState[HeadsetType.WIRED])),
              trailing: Icon(
                Icons.brightness_1,
                color: _mapStateToColor(_headsetState[HeadsetType.WIRED]),
              ),
            ),
            ListTile(
              title: Text('Current bluetooth connection state'),
              subtitle:
                  Text(_mapStateToText(_headsetState[HeadsetType.WIRELESS])),
              trailing: Icon(
                Icons.brightness_1,
                color: _mapStateToColor(_headsetState[HeadsetType.WIRELESS]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
