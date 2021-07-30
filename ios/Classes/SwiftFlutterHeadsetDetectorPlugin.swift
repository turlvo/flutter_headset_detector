import Flutter
import UIKit
import AVFoundation


public class SwiftFlutterHeadsetDetectorPlugin: NSObject, FlutterPlugin {
    var channel : FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter.moum/flutter_headset_detector", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterHeadsetDetectorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.channel = channel
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getCurrentState"){
            result(HeadsetIsConnect())
        }
    }
    
    public override init() {
        super.init()
        registerAudioRouteChangeBlock()
    }
    
    // AVAudioSessionRouteChange notification is Detaction Headphone connection status
    //(https://developer.apple.com/documentation/avfoundation/avaudiosession/responding_to_audio_session_route_changes)
    // When the AVAudioSessionRouteChange is called from notification center , the blcoking code detect the headphone connection.
    // Regular notification center work on the main UI thread but in this case it works on a particular thread.
    // So we should using blcoking.
    /////////////////////////////////////////////////////////////
    func registerAudioRouteChangeBlock(){
        NotificationCenter.default.addObserver( forName:AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance(), queue: nil) { notification in
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
            }
            
            switch reason {
            case .newDeviceAvailable:
                let session = AVAudioSession.sharedInstance()
                let headphonesConnected = self.hasHeadphones(in: session.currentRoute)

                if (headphonesConnected) {
                    self.channel!.invokeMethod("wired_connected", arguments: "true")
                } else {
                    self.channel!.invokeMethod("wireless_connected", arguments: "true")
                }
            case .oldDeviceUnavailable:
                if let previousRoute =
                    userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                    let headphonesConnected = self.hasHeadphones(in: previousRoute)
                    if (headphonesConnected) {
                        self.channel!.invokeMethod("wired_disconnected", arguments: "true")
                    } else {
                        self.channel!.invokeMethod("wireless_disconnected", arguments: "true")
                    }
                }
            default: ()
            }
        }
    }

    func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }

    func HeadsetIsConnect() -> [Int : Bool]  {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute

        var state : [Int : Bool] = [0: false, 1: false]
        for output in currentRoute.outputs {
            let portType = output.portType
            switch portType {
                case AVAudioSession.Port.headphones:
                    state[0] = true
                case AVAudioSession.Port.bluetoothA2DP:
                    state[1] = true
                case AVAudioSession.Port.bluetoothHFP:
                    state[1] = true
                default: ()
            }
        }
        return state
    }
}
