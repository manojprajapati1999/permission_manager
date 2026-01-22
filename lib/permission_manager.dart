/// A Flutter plugin for managing various app permissions on multiple platforms.
library;

import 'permission_manager_platform_interface.dart';
import 'permission_manager_types.dart';

export 'permission_manager_types.dart';

/// Main class for interacting with the permission manager.
///
/// This class provides static methods to check and request various permissions
/// across multiple platforms.
class PermissionManager {
  /// Checks the status of a specific [permission].
  ///
  /// Returns a [PermissionManagerStatus] indicating the current state of the permission.
  static Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.check(permission);
  }

  /// Requests a specific [permission] from the user.
  ///
  /// Returns a [PermissionManagerStatus] indicating the result of the request.
  static Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.request(permission);
  }

  /// Opens the application settings on the device.
  ///
  /// This can be used to direct the user to manually enable permissions if they
  /// have been permanently denied.
  static Future<void> openAppSettings() {
    return PermissionManagerPlatform.instance.openAppSettings();
  }

  /// Checks the status of multiple [permissions] at once.
  ///
  /// Returns a map where each key is a [PermissionManagerPermission] and the value
  /// is its corresponding [PermissionManagerStatus].
  static Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    return PermissionManagerPlatform.instance.checkMultiple(permissions);
  }

  /// Requests multiple [permissions] from the user at once.
  ///
  /// Returns a map where each key is a [PermissionManagerPermission] and the value
  /// is its corresponding [PermissionManagerStatus] resulting from the request.
  static Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    return PermissionManagerPlatform.instance.requestMultiple(permissions);
  }

  /// Provides a stream of [PermissionManagerStatus] for a specific [permission].
  ///
  /// Note: Support for this varies by platform.
  static Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.statusStream(permission);
  }

  /// Returns the platform version string.
  static Future<String?> getPlatformVersion() {
    return PermissionManagerPlatform.instance.getPlatformVersion();
  }
}
