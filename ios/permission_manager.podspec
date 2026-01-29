Pod::Spec.new do |s|
  s.name             = 'permission_manager'
  s.version          = '2.0.4'
  s.summary          = 'Flutter plugin to manage and request runtime permissions on Android and iOS.'
  s.description      = <<-DESC
A Flutter plugin that simplifies permission handling on Android and iOS.
It provides a unified API to check, request, and manage runtime permissions
with proper platform-specific implementations.
  DESC

  s.homepage         = 'https://pub.dev/packages/permission_manager'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Manoj Patadiya' => 'manoj.patadiya@gmail.com' }
  s.source           = { :path => '.' }

  s.source_files     = 'permission_manager/Sources/permission_manager/**/*.{h,m,swift}'
  s.resource_bundles = {
    'permission_manager' => ['Assets/**/*', 'Resources/**/*']
  }

  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

  s.swift_version = '5.9'
end
