package flutter.moum.flutter_headset_detector;

public interface HeadsetEventListener {
    void onWiredHeadsetConnect();
    void onWirelessHeadsetConnect();

    void onWiredHeadsetDisconnect();
    void onWirelessHeadsetDisconnect();
}
