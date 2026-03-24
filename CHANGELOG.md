## 2.0.9

### 📚 Documentation Improvements
- Updated README.md

## 2.0.8

### 📚 Documentation Improvements
- Updated README.md

## 2.0.7

### 📚 Documentation Improvements
- Updated README.md

## 2.0.6

### 🚀 Improvements
- Bumped minimum iOS version to 13.1

## 2.0.5

### 🐛 Bug Fixes
- Fixed Swift Package Manager (SPM) product name mismatch (`permission_manager` -> `permission-manager`)
- Fixed iOS build error caused by `CBCentralManager.authorization` requirement (Bumped minimum iOS version to 13.0)

## 2.0.4

### 🐛 Bug Fixes
- Swift Package Manager (SPM) issue fix

## 2.0.3

### 🐛 Bug Fixes
- Fixed critical iOS plugin syntax error (missing `switch` keyword) that prevented compilation
- Fixed macOS permission denial issue where permissions were denied without showing system prompts

### 📚 Documentation Improvements
- Added comprehensive **macOS Setup** section with:
  - Complete Info.plist usage descriptions guide
  - Required App Sandbox entitlements configuration
  - Troubleshooting guide for "denied without prompt" issues
- Added **Windows Setup** section explaining OS-level permission handling
- Added **Linux Setup** section with distribution-specific notes
- Added **Web Setup** section with:
  - HTTPS requirements and browser compatibility
  - Supported permissions table
  - Testing tips for localhost development
- Enhanced iOS setup section with best practices and tips

### 🔧 Example App Configuration
- Added all required permission usage descriptions to macOS example app Info.plist
- Added complete App Sandbox entitlements to macOS DebugProfile.entitlements
- Added complete App Sandbox entitlements to macOS Release.entitlements
- Ensured iOS example app has all permission descriptions

### 🏗️ Swift Package Manager
- Fixed Swift Package Manager (SPM) structure to align with Flutter official guidelines
- Resolved conflict between CocoaPods (`.podspec`) and SwiftPM (`Package.swift`)
- Moved Swift Package Manager configuration to root `.swiftpm/Package.swift`
- Ensured iOS and macOS native source files are correctly scoped under `Classes/`
- Improved compatibility with Xcode Swift Package Manager integration

> **Note for macOS Users**: If you're experiencing permission denials without prompts on macOS 14.7.5+, make sure to add the required Info.plist usage descriptions and App Sandbox entitlements as documented in the README.

## 2.0.2
- 🐛 Fixed Swift Package Manager & CocoaPods conflict

## 2.0.1
- 🐛 Fixed Swift switch-case compilation error on iOS/macOS

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
