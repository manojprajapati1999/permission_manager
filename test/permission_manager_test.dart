import 'package:flutter_test/flutter_test.dart';
import 'package:permission_manager/permission_manager.dart';
import 'package:permission_manager/permission_manager_platform_interface.dart';
import 'package:permission_manager/permission_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionManagerPlatform
    with MockPlatformInterfaceMixin
    implements PermissionManagerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<PermissionManagerStatus> check(PermissionManagerPermission permission) => Future.value(PermissionManagerStatus.granted);

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>> checkMultiple(List<PermissionManagerPermission> permissions) => Future.value({});

  @override
  Future<void> openAppSettings() => Future.value();

  @override
  Future<PermissionManagerStatus> request(PermissionManagerPermission permission) => Future.value(PermissionManagerStatus.granted);

  @override
  Future<Map<PermissionManagerPermission, PermissionManagerStatus>> requestMultiple(List<PermissionManagerPermission> permissions) => Future.value({});

  @override
  Stream<PermissionManagerStatus> statusStream(PermissionManagerPermission permission) => Stream.value(PermissionManagerStatus.granted);
}

void main() {
  final PermissionManagerPlatform initialPlatform = PermissionManagerPlatform.instance;

  test('$MethodChannelPermissionManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPermissionManager>());
  });

  test('getPlatformVersion', () async {
    MockPermissionManagerPlatform fakePlatform = MockPermissionManagerPlatform();
    PermissionManagerPlatform.instance = fakePlatform;

    expect(await PermissionManager.getPlatformVersion(), '42');
  });
}
