//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <permission_manager/permission_manager_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) permission_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PermissionManagerPlugin");
  permission_manager_plugin_register_with_registrar(permission_manager_registrar);
}
