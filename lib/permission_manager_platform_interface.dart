import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'permission_manager_method_channel.dart';
import 'permission_manager_types.dart';

abstract class PermissionManagerPlatform extends PlatformInterface {
  /// Constructs a PermissionManagerPlatform.
  PermissionManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PermissionManagerPlatform _instance =
      MethodChannelPermissionManager();

  /// The default instance of [PermissionManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPermissionManager].
  static PermissionManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PermissionManagerPlatform] when
  /// they register themselves.
  static set instance(PermissionManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('check() has not been implemented.');
  }

  Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('request() has not been implemented.');
  }

  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    throw UnimplementedError('checkMultiple() has not been implemented.');
  }

  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    throw UnimplementedError('requestMultiple() has not been implemented.');
  }

  Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('statusStream() has not been implemented.');
  }

  Future<void> openAppSettings() {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
