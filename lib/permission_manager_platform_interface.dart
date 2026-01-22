import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'permission_manager_method_channel.dart';
import 'permission_manager_types.dart';

/// The interface that implementations of permission_manager must implement.
///
/// Platform-specific implementations should extend this class and be registered
/// with [PermissionManagerPlatform.instance].
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

  /// Checks the status of a specific [permission].
  Future<PermissionManagerStatus> check(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('check() has not been implemented.');
  }

  /// Requests a specific [permission] from the user.
  Future<PermissionManagerStatus> request(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('request() has not been implemented.');
  }

  /// Checks the status of multiple [permissions] at once.
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      checkMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    throw UnimplementedError('checkMultiple() has not been implemented.');
  }

  /// Requests multiple [permissions] from the user at once.
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>>
      requestMultiple(
    List<PermissionManagerPermission> permissions,
  ) {
    throw UnimplementedError('requestMultiple() has not been implemented.');
  }

  /// Provides a stream of [PermissionManagerStatus] for a specific [permission].
  Stream<PermissionManagerStatus> statusStream(
    PermissionManagerPermission permission,
  ) {
    throw UnimplementedError('statusStream() has not been implemented.');
  }

  /// Opens the application settings on the device.
  Future<void> openAppSettings() {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
