
import FlutterMacOS
import Foundation
import AVFoundation
import CoreLocation
import Photos
import Contacts
import UserNotifications
import CoreBluetooth
import EventKit

public class PermissionManagerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "permission_manager",
      binaryMessenger: registrar.messenger
    )
    let instance = PermissionManagerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(
      name: "permission_manager_events",
      binaryMessenger: registrar.messenger
    )
    eventChannel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  public func handle(_ call: FlutterMethodCall,
                     result: @escaping FlutterResult) {

    if call.method == "openAppSettings" {
      // macOS doesn't have a single "App Settings" URL like iOS
      // But we can open system settings
      let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_All")!
      NSWorkspace.shared.open(url)
      result(nil)
      return
    }

    if call.method == "checkMultiple" {
        checkMultiple(call, result: result)
        return
    }

    if call.method == "requestMultiple" {
        requestMultiple(call, result: result)
        return
    }

    guard let args = call.arguments as? [String: Any],
          let permission = args["permission"] as? String else {
      result("denied")
      return
    }

    let shouldRequest = call.method == "request"

    case "camera", "microphone", "photos", "notifications", "contacts",
         "bluetooth", "bluetoothScan", "bluetoothConnect", "bluetoothAdvertise",
         "calendar":
        getStatus(permission, shouldRequest: shouldRequest) { status in
            self.eventSink?(status)
            result(status)
        }
    case "ignoreBatteryOptimizations", "systemAlertWindow", "scheduleExactAlarm",
         "nearbyDevices", "activityRecognition", "accessMediaLocation":
        result("denied")
    default:
        result("denied")
    }
  }

  private func checkMultiple(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let permissions = args["permissions"] as? [String] else {
      result([String: String]())
      return
    }

    var results = [String: String]()
    let group = DispatchGroup()

    for permission in permissions {
        group.enter()
        getStatus(permission, shouldRequest: false) { status in
            results[permission] = status
            self.eventSink?(status)
            group.leave()
        }
    }

    group.notify(queue: .main) {
        result(results)
    }
  }

  private func requestMultiple(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let permissions = args["permissions"] as? [String] else {
      result([String: String]())
      return
    }

    var results = [String: String]()
    let group = DispatchGroup()

    for permission in permissions {
        group.enter()
        getStatus(permission, shouldRequest: true) { status in
            results[permission] = status
            self.eventSink?(status)
            group.leave()
        }
    }

    group.notify(queue: .main) {
        result(results)
    }
  }

  private func getStatus(_ permission: String, shouldRequest: Bool, completion: @escaping (String) -> Void) {
      switch permission {
      case "camera":
          let status = AVCaptureDevice.authorizationStatus(for: .video)
          if status == .notDetermined && shouldRequest {
              AVCaptureDevice.requestAccess(for: .video) { _ in
                  DispatchQueue.main.async {
                      completion(self.mapStatus(AVCaptureDevice.authorizationStatus(for: .video)))
                  }
              }
          } else {
              completion(mapStatus(status))
          }
      case "microphone":
          let status = AVCaptureDevice.authorizationStatus(for: .audio)
          if status == .notDetermined && shouldRequest {
              AVCaptureDevice.requestAccess(for: .audio) { _ in
                  DispatchQueue.main.async {
                      completion(self.mapStatus(AVCaptureDevice.authorizationStatus(for: .audio)))
                  }
              }
          } else {
              completion(mapStatus(status))
          }
      case "photos":
          // macOS Photos permission handling
          let status = PHPhotoLibrary.authorizationStatus()
          if status == .notDetermined && shouldRequest {
              PHPhotoLibrary.requestAuthorization { _ in
                  DispatchQueue.main.async {
                      self.getStatus("photos", shouldRequest: false, completion: completion)
                  }
              }
          } else {
              switch status {
              case .authorized: completion("granted")
              case .denied: completion("denied")
              case .restricted: completion("restricted")
              case .notDetermined: completion("denied")
              @unknown default: completion("denied")
              }
          }
      case "contacts":
          let status = CNContactStore.authorizationStatus(for: .contacts)
          if status == .notDetermined && shouldRequest {
              CNContactStore().requestAccess(for: .contacts) { _, _ in
                  DispatchQueue.main.async {
                      self.getStatus("contacts", shouldRequest: false, completion: completion)
                  }
              }
          } else {
              completion(status == .authorized ? "granted" : "denied")
          }
      case "notifications":
          UNUserNotificationCenter.current().getNotificationSettings { settings in
              DispatchQueue.main.async {
                  if settings.authorizationStatus == .notDetermined && shouldRequest {
                      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                          self.getStatus("notifications", shouldRequest: false, completion: completion)
                      }
                  } else {
                      completion(settings.authorizationStatus == .authorized ? "granted" : "denied")
                  }
              }
          }
      case "bluetooth", "bluetoothScan", "bluetoothConnect", "bluetoothAdvertise":
          let status = CBCentralManager.authorization
          if status == .notDetermined && shouldRequest {
              completion("denied") 
          } else {
              completion(status == .allowedAlways ? "granted" : "denied")
          }
      case "calendar":
          let status = EKEventStore.authorizationStatus(for: .event)
          if status == .notDetermined && shouldRequest {
              EKEventStore().requestAccess(to: .event) { _, _ in
                  DispatchQueue.main.async {
                      self.getStatus("calendar", shouldRequest: false, completion: completion)
                  }
              }
          } else {
              completion(status == .authorized ? "granted" : "denied")
          }
      default:
          completion("denied")
      }
  }

  private func mapStatus(_ status: AVAuthorizationStatus) -> String {
      switch status {
      case .authorized: return "granted"
      case .denied: return "denied"
      case .restricted: return "restricted"
      case .notDetermined: return "denied"
      @unknown default: return "denied"
      }
  }
}
