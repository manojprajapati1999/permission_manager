import 'package:flutter/material.dart';
import 'package:permission_manager/permission_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PermissionExamplePage(),
    );
  }
}

class PermissionExamplePage extends StatefulWidget {
  const PermissionExamplePage({super.key});

  @override
  State<PermissionExamplePage> createState() => _PermissionExamplePageState();
}

class _PermissionExamplePageState extends State<PermissionExamplePage> {
  PermissionManagerStatus? _status;
  Map<PermissionManagerPermission, PermissionManagerStatus> _multipleStatuses = {};

  Future<void> _requestPermission(
    PermissionManagerPermission permission,
  ) async {
    final status = await PermissionManager.request(permission);

    setState(() {
      _status = status;
    });

    if (status == PermissionManagerStatus.permanentlyDenied) {
      await PermissionManager.openAppSettings();
    } else if (permission == PermissionManagerPermission.bluetooth && status == PermissionManagerStatus.denied) {
      // Special request: if Bluetooth is denied, open settings
      await PermissionManager.openAppSettings();
    }
  }

  Future<void> _requestMultiple() async {
    final results = await PermissionManager.requestMultiple([
      PermissionManagerPermission.camera,
      PermissionManagerPermission.contacts,
      PermissionManagerPermission.microphone,
      PermissionManagerPermission.mediaImages,
      PermissionManagerPermission.mediaVideo,
      PermissionManagerPermission.mediaAudio,
    ]);

    setState(() {
      _multipleStatuses = results;
    });
  }

  Widget _permissionButton({
    required String title,
    required PermissionManagerPermission permission,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () => _requestPermission(permission),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Manager')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Single Permission Requests:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _permissionButton(
              title: 'Camera',
              permission: PermissionManagerPermission.camera,
            ),
            _permissionButton(
              title: 'Microphone',
              permission: PermissionManagerPermission.microphone,
            ),
            _permissionButton(
              title: 'Notifications',
              permission: PermissionManagerPermission.notifications,
            ),
            _permissionButton(
              title: 'Bluetooth',
              permission: PermissionManagerPermission.bluetooth,
            ),
            _permissionButton(
              title: 'Calendar',
              permission: PermissionManagerPermission.calendar,
            ),
            _permissionButton(
              title: 'SMS',
              permission: PermissionManagerPermission.sms,
            ),
            _permissionButton(
              title: 'Activity Recognition',
              permission: PermissionManagerPermission.activityRecognition,
            ),
            _permissionButton(
              title: 'Media Location',
              permission: PermissionManagerPermission.accessMediaLocation,
            ),
            
            const Divider(),
            const Text('Android Specialized Permissions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _permissionButton(
              title: 'Battery Optimization',
              permission: PermissionManagerPermission.ignoreBatteryOptimizations,
            ),
            _permissionButton(
              title: 'Overlay Permission',
              permission: PermissionManagerPermission.systemAlertWindow,
            ),
            _permissionButton(
              title: 'Exact Alarm',
              permission: PermissionManagerPermission.scheduleExactAlarm,
            ),
            
            const Divider(),
            const Text('Multiple Permissions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _requestPermission(PermissionManagerPermission.mediaImages),
              child: const Text('Request Media Images'),
            ),
            ElevatedButton(
              onPressed: () => _requestPermission(PermissionManagerPermission.mediaVideo),
              child: const Text('Request Media Video'),
            ),
            ElevatedButton(
              onPressed: () => _requestPermission(PermissionManagerPermission.mediaAudio),
              child: const Text('Request Media Audio'),
            ),
            const Divider(),
            const Text('Bluetooth Details (Android 12+):', style: TextStyle(fontWeight: FontWeight.bold)),
            _permissionButton(title: 'Bluetooth Scan', permission: PermissionManagerPermission.bluetoothScan),
            _permissionButton(title: 'Bluetooth Connect', permission: PermissionManagerPermission.bluetoothConnect),
            _permissionButton(title: 'Bluetooth Advertise', permission: PermissionManagerPermission.bluetoothAdvertise),
            const Divider(),
            ElevatedButton(
              onPressed: _requestMultiple,
              child: const Text('Request Camera, Contacts, Mic, Media'),
            ),
            if (_multipleStatuses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: _multipleStatuses.entries
                      .map((e) => Text('${e.key.name}: ${e.value.name}'))
                      .toList(),
                ),
              ),
              
            const Divider(),
            const Text('Permission Stream (Camera):',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<PermissionManagerStatus>(
              stream: PermissionManager.statusStream(PermissionManagerPermission.camera),
              builder: (context, snapshot) {
                return Text('Stream Status: ${snapshot.data?.name ?? "Waiting..."}');
              },
            ),

            const SizedBox(height: 24),
            Text(
              'Last Action Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _status?.name ?? 'No permission requested',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
