# 🚀 permission_manager

A modern, **federated** Flutter plugin to manage app permissions across all platforms with a simple, unified API.

This plugin helps you **check**, **request**, and **listen** to permission states without dealing with platform-specific complexity.

## 📱 Supported Platforms

| Android | iOS | Web | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## ✨ Features

- 🏗 **Federated Architecture**: Built using a modern structure for future-proof multi-platform support.
- ✅ **Multiple Permissions**: Request or check multiple permissions simultaneously.
- 🖼 **Android 13 Media**: Granular support for Images, Video, and Audio (with backward compatibility).
- ⚡ **Real-time Updates**: Listen to permission status changes via a stream.
- 🤖 **Android Specialized**: Support for Battery Optimization, Overlay, and Exact Alarms.
- 🍏 **iOS Parity**: Handles restricted, limited, and not-determined states gracefully.
- 📦 **SPM Support**: Fully compatible with Swift Package Manager for iOS and macOS.
- 📚 **100% Documented**: Every public API element is fully documented with dartdoc comments.
- 🛠 **Simple API**: Single unified class for all operations.

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  permission_manager: ^2.0.5
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

**Minimum iOS Version: 13.0**

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

> [!TIP]
> Customize these descriptions to explain why your specific app needs each permission. Clear, user-friendly descriptions improve permission grant rates.

---

## 🖥 macOS Setup

macOS requires both **Info.plist usage descriptions** and **App Sandbox entitlements** for permissions to work correctly.

### Info.plist Usage Descriptions

Add the same usage descriptions as iOS to your `macos/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required</string>
<key>NSContactsUsageDescription</key>
<string>Contacts access is required</string>
<key>NSCalendarsUsageDescription</key>
<string>Calendar access is required</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth access is required</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location access is required</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Background location access is required</string>
<key>NSMotionUsageDescription</key>
<string>Activity recognition is required</string>
```

### App Sandbox Entitlements

Add required entitlements to **both** `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	
	<!-- Device Access -->
	<key>com.apple.security.device.camera</key>
	<true/>
	<key>com.apple.security.device.audio-input</key>
	<true/>
	
	<!-- Personal Information -->
	<key>com.apple.security.personal-information.photos-library</key>
	<true/>
	<key>com.apple.security.personal-information.addressbook</key>
	<true/>
	<key>com.apple.security.personal-information.calendars</key>
	<true/>
	<key>com.apple.security.personal-information.location</key>
	<true/>
	
	<!-- File Access (if needed) -->
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
	
	<!-- Network (usually needed for Flutter apps) -->
	<key>com.apple.security.network.client</key>
	<true/>
</dict>
</plist>
```

> [!WARNING]
> **Missing entitlements or Info.plist keys will cause permissions to be denied silently without showing any prompt to the user.** This is the most common issue on macOS 14.7.5+.

### Troubleshooting macOS Permissions

If permissions are always denied without prompts:

1. ✅ Verify all required `NSxxxUsageDescription` keys are in `Info.plist`
2. ✅ Verify all required entitlements are in **both** `.entitlements` files
3. ✅ Clean build folder: `flutter clean` then rebuild
4. ✅ Reset permissions: `tccutil reset All com.your.bundle.identifier`
5. ✅ Check Console.app for permission-related errors

---

## 🪟 Windows Setup

Windows doesn't require manifest changes for most permissions. The plugin handles permissions at the OS level.

> [!NOTE]
> Some permissions (like camera/microphone) may require user consent through Windows Settings. The plugin will guide users to the appropriate settings page when needed.

---

## 🐧 Linux Setup

Linux permissions are typically handled at the OS level through system policies.

> [!NOTE]
> Depending on your Linux distribution and desktop environment, you may need to configure permissions through system settings or PolicyKit rules.

---

## 🌐 Web Setup

Web permissions use the browser's native Permissions API and are requested automatically.

### Requirements

- **HTTPS Required**: Most permissions (camera, microphone, location) require a secure context (HTTPS)
- **User Gesture**: Some permissions must be requested in response to user interaction

### Supported Permissions on Web

| Permission | Support | Notes |
|:---|:---:|:---|
| Camera | ✅ | Requires HTTPS |
| Microphone | ✅ | Requires HTTPS |
| Location | ✅ | Requires HTTPS |
| Notifications | ✅ | Works on HTTP |
| Bluetooth | ⚠️ | Limited browser support |
| Others | ❌ | Not available in browsers |

> [!TIP]
> Test web permissions on `localhost` (allowed without HTTPS) or deploy to a secure HTTPS server.

---

## 📝 License
This package is available under the MIT License.

## 👨‍💻 Author
**Manoj Patadiya**
📧 Email: patadiyamanoj4@gmail.com


