import Flutter
import UIKit
import GoogleMaps  // [新增] 引入 Google Maps 函式庫

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // [新增] 設定 Google Maps API Key
    // 請確認這組 Key 在 Google Cloud Console 有啟用 "Maps SDK for iOS"
    GMSServices.provideAPIKey("AIzaSyCoA9N2JWrzGMiPiIvfs-iCWCbJnx91Uag")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}