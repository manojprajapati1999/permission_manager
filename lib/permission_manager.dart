import 'permission_manager_platform_interface.dart';
import 'permission_manager_types.dart';

export 'permission_manager_types.dart';

class PermissionManager {
  static Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.check(permission);
  }

  static Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.request(permission);
  }

  static Future<void> openAppSettings() {
    return PermissionManagerPlatform.instance.openAppSettings();
  }

  static Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    return PermissionManagerPlatform.instance.checkMultiple(permissions);
  }

  static Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    return PermissionManagerPlatform.instance.requestMultiple(permissions);
  }

  static Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    return PermissionManagerPlatform.instance.statusStream(permission);
  }

  static Future<String?> getPlatformVersion() {
    return PermissionManagerPlatform.instance.getPlatformVersion();
  }
}
