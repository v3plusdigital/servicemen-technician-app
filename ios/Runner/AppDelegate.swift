import Flutter
import UIKit
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate{
  var locationManager: CLLocationManager!
    var channel: FlutterMethodChannel!
    var locationTimer: Timer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

 let controller = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(
      name: "ios_location_channel",
      binaryMessenger: controller.binaryMessenger
    )

  channel.setMethodCallHandler { call, result in
        if call.method == "startTracking" {
          self.startTracking()
          result(true)
        } else if call.method == "stopTracking" {
          self.stopTracking()
          result(true)
        }
      }

      locationManager = CLLocationManager()
      locationManager.delegate = self
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.pausesLocationUpdatesAutomatically = false
      locationManager.requestAlwaysAuthorization()



    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startTracking() {
      // Send location immediately
      requestAndSendLocation()

      // Then send location every 2 minutes
      locationTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [weak self] _ in
        self?.requestAndSendLocation()
      }
    }

    func stopTracking() {
      locationTimer?.invalidate()
      locationTimer = nil
      locationManager.stopUpdatingLocation()
    }

    func requestAndSendLocation() {
      locationManager.startUpdatingLocation()
    }

    func locationManager(
      _ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]
    ) {
      guard let loc = locations.last else { return }

      // Stop updating to save battery (we'll request again after 2 minutes)
      locationManager.stopUpdatingLocation()

      channel.invokeMethod("onLocation", arguments: [
        "lat": loc.coordinate.latitude,
        "lng": loc.coordinate.longitude
      ])
    }
}
