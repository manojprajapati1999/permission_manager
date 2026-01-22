/// Defines the various permissions that can be managed.
enum PermissionManagerPermission {
  /// Access to the device's camera.
  camera,

  /// Access to the device's microphone.
  microphone,

  /// Access to the device's location.
  location,

  /// Access to the device's location even when the app is in the background.
  locationAlways,

  /// Access to the device's external storage.
  storage,

  /// Access to the device's photo library.
  photos,

  /// Sending notifications to the user.
  notifications,

  /// Access to the device's contacts.
  contacts,

  /// Access to the device's phone state and features.
  phone,

  /// Android specific: Request to ignore battery optimizations.
  ignoreBatteryOptimizations,

  /// Android specific: Request to draw over other apps.
  systemAlertWindow,

  /// Android specific: Request to schedule exact alarms.
  scheduleExactAlarm,

  /// Android 13+ Media: Access to video files.
  mediaImages,

  /// Android 13+ Media: Access to video files.
  mediaVideo,

  /// Android 13+ Media: Access to audio files.
  mediaAudio,

  /// Access to Bluetooth features.
  bluetooth,

  /// Access to scanning for nearby Bluetooth devices.
  bluetoothScan,

  /// Access to connecting with paired Bluetooth devices.
  bluetoothConnect,

  /// Access to advertising the device to other Bluetooth devices.
  bluetoothAdvertise,

  /// Access to scanning for nearby devices using Bluetooth, Wi-Fi, or other technologies.
  nearbyDevices,

  /// Access to the device's calendar.
  calendar,

  /// Access to the device's SMS features.
  sms,

  /// Permission to send SMS messages.
  sendSms,

  /// Access to activity recognition data.
  activityRecognition,

  /// Access to the location of media files.
  accessMediaLocation,
}

/// Represents the status of a permission.
enum PermissionManagerStatus {
  /// The permission has been granted by the user.
  granted,

  /// The permission has been denied by the user.
  denied,

  /// The permission has been permanently denied.
  ///
  /// On some platforms, the user must go to the app settings to change this.
  permanentlyDenied,

  /// The permission is restricted (iOS only).
  restricted,

  /// The permission is limited (iOS photos only).
  limited,
}
