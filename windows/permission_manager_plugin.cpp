#include "permission_manager_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>
#include <shellapi.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>

namespace permission_manager {

// static
    void PermissionManagerPlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarWindows *registrar) {
        auto channel =
                std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                        registrar->messenger(),
                                "permission_manager",
                                &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<PermissionManagerPlugin>();

        channel->SetMethodCallHandler(
                [plugin_pointer = plugin.get()](const auto& call, auto result) {
                    plugin_pointer->HandleMethodCall(call, std::move(result));
                });

        registrar->AddPlugin(std::move(plugin));
    }

    PermissionManagerPlugin::PermissionManagerPlugin() {}

    PermissionManagerPlugin::~PermissionManagerPlugin() {}

    void PermissionManagerPlugin::HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue>& method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        if (method_call.method_name() == "getPlatformVersion") {

            result->Success(flutter::EncodableValue("Windows"));

        } else if (method_call.method_name() == "check" ||
                   method_call.method_name() == "request") {

            // Windows doesn't handle permissions like Android/iOS.
            // Returning granted by default.
            result->Success(flutter::EncodableValue("granted"));

        } else if (method_call.method_name() == "checkMultiple" ||
                   method_call.method_name() == "requestMultiple") {

            flutter::EncodableMap response;

            const auto* arguments =
                    std::get_if<flutter::EncodableMap>(method_call.arguments());

            if (arguments) {
                auto it = arguments->find(
                        flutter::EncodableValue("permissions"));

                if (it != arguments->end()) {
                    const auto* permissions =
                            std::get_if<flutter::EncodableList>(&it->second);

                    if (permissions) {
                        for (const auto& permission : *permissions) {
                            if (const auto* permission_str =
                                    std::get_if<std::string>(&permission)) {

                                response[flutter::EncodableValue(*permission_str)] =
                                        flutter::EncodableValue("granted");
                            }
                        }
                    }
                }
            }

            result->Success(flutter::EncodableValue(response));

        } else if (method_call.method_name() == "openAppSettings") {

            // Open Windows Privacy Settings
            ShellExecuteA(
                    nullptr,
                    "open",
                    "ms-settings:privacy",
                    nullptr,
                    nullptr,
                    SW_SHOWNORMAL);

            // Dart expects Future<void>
            result->Success();

        } else {

            result->NotImplemented();
        }
    }

}  // namespace permission_manager