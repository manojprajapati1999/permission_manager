#include "include/permission_manager/permission_manager_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "permission_manager_plugin.h"

void PermissionManagerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  permission_manager::PermissionManagerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
