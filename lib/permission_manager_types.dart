enum PermissionManagerPermission {
  camera,
  microphone,
  location,
  locationAlways,
  storage,
  photos,
  notifications,
  contacts,
  phone,
  // Android specific
  ignoreBatteryOptimizations,
  systemAlertWindow,
  scheduleExactAlarm,
  // Android 13+ Media
  mediaImages,
  mediaVideo,
  mediaAudio,
  // New permissions
  bluetooth,
  bluetoothScan,
  bluetoothConnect,
  bluetoothAdvertise,
  nearbyDevices,
  calendar,
  sms,
  sendSms,
  activityRecognition,
  accessMediaLocation,
}

enum PermissionManagerStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted, // iOS
  limited, // iOS photos
}
