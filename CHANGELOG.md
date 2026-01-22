## 2.0.0

- **🚀 Full Linux Support**: Added native implementation for Linux platform mapping, achieving parity across all 6 Flutter platforms.
- **📦 Swift Package Manager (SPM) Support**: Integrated `Package.swift` for both iOS and macOS, enabling modern dependency management.
- **📚 100% Documentation Coverage**: Added comprehensive dartdoc comments for all public API members (classes, methods, enums).
- **🛠 Improved Code Quality**: Enabled `public_member_api_docs` lint and resolved all analysis warnings.
- **🧪 Enhanced Testing**: Updated unit tests to support the expanded platform interface and verified functionality.

## 1.0.0

### 🚀 Features

- **🏗 Federated Architecture**: Refactored to a modern federated structure for robust cross-platform extensibility.
- **🌐 Expanded Platform Support**:
    - **Android & iOS**: Optimized native implementations for all permissions.
    - **Web**: Initial support for core permissions using the Browser Permissions API.
    - **macOS**: Full native support with parity to iOS.
    - **Windows**: Infrastructure added for future expansion.
- **📡 Real-time Updates**: Listen to permission status changes via `statusStream()`.
- **📦 Batch Operations**: Check or request multiple permissions simultaneously with `checkMultiple()` and `requestMultiple()`.
- **🤖 Specialized Android Permissions**:
    - Battery Optimization bypass.
    - System Alert Window (Overlay).
    - Schedule Exact Alarms.
- **🖼 Granular Media Support (Android 13+)**:
    - `mediaImages`, `mediaVideo`, and `mediaAudio` support.

### ✅ Supported Permissions

- **General**: Camera, Microphone, Location (Always/InUse), Contacts, Phone, Notifications, Photos, Storage.
- **Bluetooth**: `bluetooth`, `bluetoothScan`, `bluetoothConnect`, `bluetoothAdvertise`.
- **Connectivity**: `nearbyDevices`.
- **Productivity**: `calendar`.
- **Messaging**: `sms`, `sendSms` (Android).
- **Health**: `activityRecognition`.
- **Media**: `accessMediaLocation`.

### 📱 Supported Statuses
- `granted`, `denied`, `permanentlyDenied` (Android), `restricted` (iOS/macOS), `limited` (iOS/macOS Photos).
