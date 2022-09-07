package flutter.moum.flutter_headset_detector;

public interface HeadsetEventListener {
    void onWiredHeadsetConnect(String name,int micState);
    void onWirelessHeadsetConnect();

    void onWiredHeadsetDisconnect(String name,int micState);
    void onWirelessHeadsetDisconnect();
}
