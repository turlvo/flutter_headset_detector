import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_headset_detector/flutter_headset_detector.dart';

typedef DetectPluggedCallback = Function(HeadsetChangedEvent payload);

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  MockMethodChannel? _methodChannel;
  late HeadsetDetector _he;

  setUp(() {
    _methodChannel = MockMethodChannel();
    _he = HeadsetDetector.private(_methodChannel);
  });

  test('getCurrentState', () async {
    when(_methodChannel!.invokeMethod('getCurrentState')).thenAnswer(
      (Invocation invoke) => Future.value(
        {
          0: false,
          1: false,
        },
      ),
    );

    expect(
      await _he.getCurrentState,
      {
        HeadsetType.WIRED: HeadsetState.DISCONNECTED,
        HeadsetType.WIRELESS: HeadsetState.DISCONNECTED,
      },
    );

    when(_methodChannel!.invokeMethod('getCurrentState')).thenAnswer(
      (Invocation invoke) => Future.value(
        {
          0: true,
          1: false,
        },
      ),
    );

    expect(
      await _he.getCurrentState,
      {
        HeadsetType.WIRED: HeadsetState.CONNECTED,
        HeadsetType.WIRELESS: HeadsetState.DISCONNECTED,
      },
    );

    when(_methodChannel!.invokeMethod('getCurrentState')).thenAnswer(
      (Invocation invoke) => Future.value(
        {
          0: false,
          1: true,
        },
      ),
    );

    expect(
      await _he.getCurrentState,
      {
        HeadsetType.WIRED: HeadsetState.DISCONNECTED,
        HeadsetType.WIRELESS: HeadsetState.CONNECTED,
      },
    );
  });
}
