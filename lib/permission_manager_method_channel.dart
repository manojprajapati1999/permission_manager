import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'permission_manager_platform_interface.dart';
import 'permission_manager_types.dart';

/// An implementation of [PermissionManagerPlatform] that uses method channels.
class MethodChannelPermissionManager extends PermissionManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('permission_manager');

  @visibleForTesting
  final eventChannel = const EventChannel('permission_manager_events');

  @override
  Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) async {
    final result = await methodChannel.invokeMethod<String>(
      'check',
      {'permission': permission.name},
    );
    return PermissionManagerStatus.values.byName(result!);
  }

  @override
  Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) async {
    final result = await methodChannel.invokeMethod<String>(
      'request',
      {'permission': permission.name},
    );
    return PermissionManagerStatus.values.byName(result!);
  }

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) async {
    final Map<String, String> result =
        await methodChannel.invokeMapMethod<String, String>(
      'checkMultiple',
      {'permissions': permissions.map((p) => p.name).toList()},
    ) ??
    {};

    return result.map((key, value) => MapEntry(
          PermissionManagerPermission.values.byName(key),
          PermissionManagerStatus.values.byName(value),
        ));
  }

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) async {
    final Map<String, String> result =
        await methodChannel.invokeMapMethod<String, String>(
      'requestMultiple',
      {'permissions': permissions.map((p) => p.name).toList()},
    ) ??
    {};

    return result.map((key, value) => MapEntry(
          PermissionManagerPermission.values.byName(key),
          PermissionManagerStatus.values.byName(value),
        ));
  }

  @override
  Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    return eventChannel
        .receiveBroadcastStream({'permission': permission.name}).map(
      (event) => PermissionManagerStatus.values.byName(event as String),
    );
  }

  @override
  Future<void> openAppSettings() async {
    await methodChannel.invokeMethod('openAppSettings');
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
