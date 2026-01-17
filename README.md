# 🚀 permission_manager

A modern, **federated** Flutter plugin to manage app permissions across all platforms with a simple, unified API.

This plugin helps you **check**, **request**, and **listen** to permission states without dealing with platform-specific complexity.

## 📱 Supported Platforms

| Android | iOS | Web | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ | 🚧 |

## ✨ Features

- 🏗 **Federated Architecture**: Built using a modern structure for future-proof multi-platform support.
- ✅ **Multiple Permissions**: Request or check multiple permissions simultaneously.
- 🖼 **Android 13 Media**: Granular support for Images, Video, and Audio (with backward compatibility).
- ⚡ **Real-time Updates**: Listen to permission status changes via a stream.
- 🤖 **Android Specialized**: Support for Battery Optimization, Overlay, and Exact Alarms.
- 🍏 **iOS Parity**: Handles restricted, limited, and not-determined states gracefully.
- 🛠 **Simple API**: Single unified class for all operations.

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  permission_manager: ^1.0.0
```

##  Usage

### 🔐 Request a Permission
```dart
import 'package:permission_manager/permission_manager.dart';

final status = await PermissionManager.request(
  PermissionManagerPermission.camera,
);

if (status == PermissionManagerStatus.granted) {
  // Permission granted
} else if (status == PermissionManagerStatus.permanentlyDenied) {
  // Open app settings
  await PermissionManager.openAppSettings();
}
```

###  Request Multiple Permissions
```dart
final statuses = await PermissionManager.requestMultiple([
  PermissionManagerPermission.camera,
  PermissionManagerPermission.location,
  PermissionManagerPermission.contacts,
]);

print(statuses[PermissionManagerPermission.camera]);
```

### 📡 Listen to Status Changes
```dart
PermissionManager.statusStream(PermissionManagerPermission.camera).listen((status) {
  print('Camera status changed to: $status');
});
```

## 🔍 Supported Permissions

| Permission Enum | Platform Support | Description |
|:--- |:---:|:--- |
| `PermissionManagerPermission.camera` | All | Access to camera device |
| `PermissionManagerPermission.microphone` | All | Access to microphone/audio recording |
| `PermissionManagerPermission.location` | All | Access to device location (While in Use) |
| `PermissionManagerPermission.locationAlways` | Android/iOS | Access to background location |
| `PermissionManagerPermission.contacts` | All | Access to device contacts |
| `PermissionManagerPermission.notifications` | All | System notification access |
| `PermissionManagerPermission.photos` | All | Photo library access |
| `PermissionManagerPermission.storage` | Android/iOS | General storage access (Gallery/Files) |
| `PermissionManagerPermission.phone` | Android | Read phone state |
| `PermissionManagerPermission.bluetooth` | All | Bluetooth access |
| `PermissionManagerPermission.bluetoothScan` | Android 12+/Web | Bluetooth scanning |
| `PermissionManagerPermission.bluetoothConnect` | Android 12+ | Bluetooth connection |
| `PermissionManagerPermission.bluetoothAdvertise` | Android 12+ | Bluetooth advertising |
| `PermissionManagerPermission.nearbyDevices` | Android 13+ | Nearby Wi-Fi/Bluetooth devices |
| `PermissionManagerPermission.calendar` | All | Access to calendar events |
| `PermissionManagerPermission.sms` | Android | Read SMS messages |
| `PermissionManagerPermission.sendSms` | Android | Send SMS messages |
| `PermissionManagerPermission.activityRecognition` | Android/iOS | Fitness/Activity tracking |
| `PermissionManagerPermission.accessMediaLocation` | Android 10+ | Access EXIF location data |
| `PermissionManagerPermission.mediaImages` | Android 13+ | Granular access to images only |
| `PermissionManagerPermission.mediaVideo` | Android 13+ | Granular access to video only |
| `PermissionManagerPermission.mediaAudio` | Android 13+ | Granular access to audio only |
| `PermissionManagerPermission.ignoreBatteryOptimizations` | Android | Requests to bypass battery saving |
| `PermissionManagerPermission.systemAlertWindow` | Android | Display over other apps (Overlay) |
| `PermissionManagerPermission.scheduleExactAlarm` | Android | Schedule precise alarms |

## 🤖 Android Setup

Add required permissions to your `AndroidManifest.xml`:

```xml
<!-- General -->
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />

<!-- Bluetooth & Connectivity -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" />

<!-- SMS -->
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.SEND_SMS" />

<!-- Media & Activity -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />

<!-- Specialized -->
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

## 🍎 iOS Setup

Add usage descriptions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required</string>
<key>NSContactsUsageDescription</key>
<string>Contacts access is required</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth access is required</string>
<key>NSCalendarsUsageDescription</key>
<string>Calendar access is required</string>
<key>NSMotionUsageDescription</key>
<string>Activity recognition is required</string>
```

## 📝 License
This package is available under the MIT License.

## 👨‍💻 Author
**Manoj Patadiya**
📧 Email: patadiyamanoj4@gmail.com


