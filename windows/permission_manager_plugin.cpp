#include "permission_manager_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace permission_manager {

// static
void PermissionManagerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "permission_manager",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<PermissionManagerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

PermissionManagerPlugin::PermissionManagerPlugin() {}

PermissionManagerPlugin::~PermissionManagerPlugin() {}

void PermissionManagerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name() == "getPlatformVersion") {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else {
      version_stream << "older";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name() == "check" || method_call.method_name() == "request") {
    // Windows doesn't handle most of these permissions via standard prompts in same way
    // For now, return granted for storage/notifications as baseline or denied
    result->Success(flutter::EncodableValue("granted"));
  } else if (method_call.method_name() == "checkMultiple" || method_call.method_name() == "requestMultiple") {
    flutter::EncodableMap response;
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
        auto it = arguments->find(flutter::EncodableValue("permissions"));
        if (it != arguments->end()) {
            const auto* permissions = std::get_if<flutter::EncodableList>(&it->second);
            if (permissions) {
                for (const auto& p : *permissions) {
                    if (const auto* p_str = std::get_if<std::string>(&p)) {
                        response[flutter::EncodableValue(*p_str)] = flutter::EncodableValue("granted");
                    }
                }
            }
        }
    }
    result->Success(flutter::EncodableValue(response));
  } else if (method_call.method_name() == "openAppSettings") {
    // Open Windows settings
    system("start ms-settings:privacy");
    result->Success();
  } else {
    result->NotImplemented();
  }
}

}  // namespace permission_manager
