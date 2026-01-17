import 'package:web/web.dart' as web;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js_interop';
import 'permission_manager_platform_interface.dart';
import 'permission_manager_types.dart';

/// A web implementation of the PermissionManagerPlatform of the PermissionManager plugin.
class PermissionManagerWeb extends PermissionManagerPlatform {
  /// Constructs a PermissionManagerWeb.
  PermissionManagerWeb();

  static void registerWith(Registrar registrar) {
    PermissionManagerPlatform.instance = PermissionManagerWeb();
  }

  @override
  Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) async {
    final status = await _getWebPermissionStatus(permission);
    return status;
  }

  @override
  Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) async {
    return check(permission);
  }

  Future<PermissionManagerStatus> _getWebPermissionStatus(
    PermissionManagerPermission permission,
  ) async {
    final permissions = web.window.navigator.permissions;

    String? webPermissionName;
    switch (permission) {
      case PermissionManagerPermission.camera:
        webPermissionName = 'camera';
        break;
      case PermissionManagerPermission.microphone:
        webPermissionName = 'microphone';
        break;
      case PermissionManagerPermission.notifications:
        webPermissionName = 'notifications';
        break;
      case PermissionManagerPermission.location:
        webPermissionName = 'geolocation';
        break;
      case PermissionManagerPermission.bluetooth:
      case PermissionManagerPermission.bluetoothScan:
      case PermissionManagerPermission.bluetoothConnect:
      case PermissionManagerPermission.bluetoothAdvertise:
        webPermissionName = 'bluetooth';
        break;
      default:
        return PermissionManagerStatus.denied;
    }

    try {
      final status = await permissions.query({'name': webPermissionName}.jsify() as JSObject).toDart;
      switch (status.state) {
        case 'granted':
          return PermissionManagerStatus.granted;
        case 'prompt':
          return PermissionManagerStatus.denied;
        case 'denied':
          return PermissionManagerStatus.permanentlyDenied;
        default:
          return PermissionManagerStatus.denied;
      }
    } catch (e) {
      return PermissionManagerStatus.denied;
    }
  }

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) async {
    final results = <PermissionManagerPermission, PermissionManagerStatus>{};
    for (final p in permissions) {
      results[p] = await check(p);
    }
    return results;
  }

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) async {
    return checkMultiple(permissions);
  }

  @override
  Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    // Placeholder for web stream
    return Stream.empty();
  }

  @override
  Future<void> openAppSettings() async {
    // No direct "App Settings" on Web
  }
}
