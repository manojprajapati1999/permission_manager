package com.me.permission_manager

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.os.Build
import android.os.PowerManager
import android.content.Context
class PermissionManagerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private var activity: Activity? = null
  private var context: Context? = null
  private var pendingResult: MethodChannel.Result? = null
  private var pendingPermissions: Array<String>? = null

  private val REQUEST_CODE = 5001

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "permission_manager")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(binding.binaryMessenger, "permission_manager_events")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
      }
      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "check" -> checkPermission(call, result)
      "request" -> requestPermission(call, result)
      "checkMultiple" -> checkMultiplePermissions(call, result)
      "requestMultiple" -> requestMultiplePermissions(call, result)
      "openAppSettings" -> openSettings(result)
      else -> result.notImplemented()
    }
  }

  private fun checkPermission(call: MethodCall, result: MethodChannel.Result) {
    val permissionName = call.argument<String>("permission")!!
    result.success(getPermissionStatus(permissionName))
  }

  private fun getPermissionStatus(permissionName: String): String {
    val currentContext = activity ?: context ?: return "denied"
    val packageName = currentContext.packageName

    return when (permissionName) {
      "ignoreBatteryOptimizations" -> {
        val powerManager = currentContext.getSystemService(Context.POWER_SERVICE) as? PowerManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          if (powerManager?.isIgnoringBatteryOptimizations(packageName) == true) "granted" else "denied"
        } else "granted"
      }
      "systemAlertWindow" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          if (Settings.canDrawOverlays(currentContext)) "granted" else "denied"
        } else "granted"
      }
      "scheduleExactAlarm" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
          val alarmManager = currentContext.getSystemService(Context.ALARM_SERVICE) as? android.app.AlarmManager
          if (alarmManager?.canScheduleExactAlarms() == true) "granted" else "denied"
        } else "granted"
      }
      else -> {
        val permission = mapPermission(permissionName)
        val status = ContextCompat.checkSelfPermission(currentContext, permission)
        if (status == PackageManager.PERMISSION_GRANTED) "granted" else "denied"
      }
    }
  }

  private fun requestPermission(call: MethodCall, result: MethodChannel.Result) {
    val permissionName = call.argument<String>("permission")!!
    
    when (permissionName) {
      "ignoreBatteryOptimizations" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          val currentContext = activity ?: context
          val packageName = currentContext?.packageName ?: ""
          
          try {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
              data = Uri.parse("package:$packageName")
              if (activity == null) {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
              }
            }
            activity?.startActivity(intent) ?: context?.startActivity(intent)
          } catch (e: Exception) {
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
              if (activity == null) {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
              }
            }
            activity?.startActivity(intent) ?: context?.startActivity(intent)
          }
        }
        result.success(getPermissionStatus(permissionName))
      }
      "systemAlertWindow" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          val currentContext = activity ?: context
          val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION).apply {
            data = Uri.parse("package:${currentContext?.packageName}")
            if (activity == null) {
              flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
          }
          activity?.startActivity(intent) ?: context?.startActivity(intent)
        }
        result.success(getPermissionStatus(permissionName))
      }
      "scheduleExactAlarm" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
          val currentContext = activity ?: context
          val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
            data = Uri.parse("package:${currentContext?.packageName}")
            if (activity == null) {
              flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
          }
          activity?.startActivity(intent) ?: context?.startActivity(intent)
        }
        result.success(getPermissionStatus(permissionName))
      }
      else -> {
        val currentActivity = activity
        if (currentActivity == null) {
          result.error("NO_ACTIVITY", "Activity is null", null)
          return
        }
        
        // Return status immediately if already granted (handles normal permissions)
        if (getPermissionStatus(permissionName) == "granted") {
          result.success("granted")
          return
        }

        pendingResult = result
        val permission = mapPermission(permissionName)
        pendingPermissions = arrayOf(permission)

        ActivityCompat.requestPermissions(
          currentActivity,
          arrayOf(permission),
          REQUEST_CODE
        )
      }
    }
  }

  private fun checkMultiplePermissions(call: MethodCall, result: MethodChannel.Result) {
    val permissions = call.argument<List<String>>("permissions")!!
    val results = mutableMapOf<String, String>()
    for (p in permissions) {
      results[p] = getPermissionStatus(p)
    }
    result.success(results)
  }

  private fun requestMultiplePermissions(call: MethodCall, result: MethodChannel.Result) {
    val permissions = call.argument<List<String>>("permissions")!!
    
    // Split into normal permissions and special settings permissions
    val normalPermissions = permissions.filter { 
      it != "ignoreBatteryOptimizations" && it != "systemAlertWindow" && it != "scheduleExactAlarm" 
    }
    
    // We can't easily request multiple special permissions at once if they require separate intent calls
    // For now, we request normal permissions and return denied for others if mixed
    if (normalPermissions.isNotEmpty()) {
      pendingResult = result
      pendingPermissions = normalPermissions.map { mapPermission(it) }.toTypedArray()
      ActivityCompat.requestPermissions(activity!!, pendingPermissions!!, REQUEST_CODE)
    } else {
      // If only special permissions, handle the first one for now or return current status
      val results = mutableMapOf<String, String>()
      for (p in permissions) {
        results[p] = getPermissionStatus(p)
      }
      result.success(results)
    }
  }

  private fun openSettings(result: MethodChannel.Result) {
    val intent = Intent(
      Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
      Uri.parse("package:${activity?.packageName}")
    )
    activity?.startActivity(intent)
    result.success(null)
  }

  private fun mapPermission(permission: String): String =
    when (permission) {
      "camera" -> android.Manifest.permission.CAMERA
      "microphone" -> android.Manifest.permission.RECORD_AUDIO
      "location" -> android.Manifest.permission.ACCESS_FINE_LOCATION
      "locationAlways" -> android.Manifest.permission.ACCESS_BACKGROUND_LOCATION
      "storage" -> android.Manifest.permission.READ_EXTERNAL_STORAGE
      "notifications" -> android.Manifest.permission.POST_NOTIFICATIONS
      "contacts" -> android.Manifest.permission.READ_CONTACTS
      "phone" -> android.Manifest.permission.READ_PHONE_STATE
      "ignoreBatteryOptimizations" -> "android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"
      "systemAlertWindow" -> android.Manifest.permission.SYSTEM_ALERT_WINDOW
      "scheduleExactAlarm" -> android.Manifest.permission.SCHEDULE_EXACT_ALARM
      "mediaImages" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        android.Manifest.permission.READ_MEDIA_IMAGES
      } else {
        android.Manifest.permission.READ_EXTERNAL_STORAGE
      }
      "mediaVideo" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        android.Manifest.permission.READ_MEDIA_VIDEO
      } else {
        android.Manifest.permission.READ_EXTERNAL_STORAGE
      }
      "mediaAudio" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        android.Manifest.permission.READ_MEDIA_AUDIO
      } else {
        android.Manifest.permission.READ_EXTERNAL_STORAGE
      }
      "bluetooth" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        android.Manifest.permission.BLUETOOTH_CONNECT
      } else {
        android.Manifest.permission.BLUETOOTH
      }
      "bluetoothScan" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        android.Manifest.permission.BLUETOOTH_SCAN
      } else {
        android.Manifest.permission.BLUETOOTH
      }
      "bluetoothConnect" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        android.Manifest.permission.BLUETOOTH_CONNECT
      } else {
        android.Manifest.permission.BLUETOOTH
      }
      "bluetoothAdvertise" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        android.Manifest.permission.BLUETOOTH_ADVERTISE
      } else {
        android.Manifest.permission.BLUETOOTH
      }
      "nearbyDevices" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        android.Manifest.permission.NEARBY_WIFI_DEVICES
      } else {
        android.Manifest.permission.ACCESS_FINE_LOCATION
      }
      "calendar" -> android.Manifest.permission.READ_CALENDAR
      "sms" -> android.Manifest.permission.READ_SMS
      "sendSms" -> android.Manifest.permission.SEND_SMS
      "activityRecognition" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        android.Manifest.permission.ACTIVITY_RECOGNITION
      } else {
        "com.google.android.gms.permission.ACTIVITY_RECOGNITION"
      }
      "accessMediaLocation" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        android.Manifest.permission.ACCESS_MEDIA_LOCATION
      } else {
        android.Manifest.permission.READ_EXTERNAL_STORAGE
      }
      else -> throw IllegalArgumentException("Unknown permission: $permission")
    }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener { _, permissions, results ->
      val response = mutableMapOf<String, String>()
      
      for (i in permissions.indices) {
        val permission = permissions[i]
        val granted = results[i] == PackageManager.PERMISSION_GRANTED
        val dartPermissionName = mapAndroidPermissionToDart(permission)

        if (granted) {
          response[dartPermissionName] = "granted"
        } else {
          val currentActivity = activity
          val permanentlyDenied = if (currentActivity != null) {
            !ActivityCompat.shouldShowRequestPermissionRationale(currentActivity, permission)
          } else {
            false
          }
          response[dartPermissionName] = if (permanentlyDenied) "permanentlyDenied" else "denied"
        }
      }

      if (pendingPermissions?.size == 1) {
        pendingResult?.success(response.values.first())
      } else {
        pendingResult?.success(response)
      }

      pendingResult = null
      pendingPermissions = null
      
      // Update event sink if listener exists
      response.forEach { (name, status) ->
        eventSink?.success(status)
      }
      
      true
    }
  }

  private fun mapAndroidPermissionToDart(permission: String): String =
    when (permission) {
      android.Manifest.permission.CAMERA -> "camera"
      android.Manifest.permission.RECORD_AUDIO -> "microphone"
      android.Manifest.permission.ACCESS_FINE_LOCATION -> "location"
      android.Manifest.permission.ACCESS_BACKGROUND_LOCATION -> "locationAlways"
      android.Manifest.permission.READ_EXTERNAL_STORAGE -> "storage"
      android.Manifest.permission.POST_NOTIFICATIONS -> "notifications"
      android.Manifest.permission.READ_CONTACTS -> "contacts"
      android.Manifest.permission.READ_PHONE_STATE -> "phone"
      "android.permission.READ_MEDIA_IMAGES" -> "mediaImages"
      "android.permission.READ_MEDIA_VIDEO" -> "mediaVideo"
      "android.permission.READ_MEDIA_AUDIO" -> "mediaAudio"
      android.Manifest.permission.BLUETOOTH_SCAN -> "bluetoothScan"
      android.Manifest.permission.BLUETOOTH_CONNECT -> "bluetoothConnect"
      android.Manifest.permission.BLUETOOTH_ADVERTISE -> "bluetoothAdvertise"
      "android.permission.NEARBY_WIFI_DEVICES" -> "nearbyDevices"
      android.Manifest.permission.READ_CALENDAR -> "calendar"
      android.Manifest.permission.READ_SMS -> "sms"
      android.Manifest.permission.SEND_SMS -> "sendSms"
      "android.permission.ACTIVITY_RECOGNITION" -> "activityRecognition"
      "android.permission.ACCESS_MEDIA_LOCATION" -> "accessMediaLocation"
      android.Manifest.permission.BLUETOOTH -> "bluetooth"
      android.Manifest.permission.ACCESS_COARSE_LOCATION -> "location"
      android.Manifest.permission.WRITE_EXTERNAL_STORAGE -> "storage"
      android.Manifest.permission.WRITE_CONTACTS -> "contacts"
      android.Manifest.permission.READ_CALENDAR -> "calendar"
      android.Manifest.permission.WRITE_CALENDAR -> "calendar"
      else -> "unknown"
    }

  override fun onDetachedFromActivity() { activity = null }
  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
