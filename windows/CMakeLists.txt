cmake_minimum_required(VERSION 3.14)
project(permission_manager_plugin LANGUAGES CXX)

add_library(permission_manager_plugin SHARED
  permission_manager_plugin.cpp
  permission_manager_plugin.h
)

target_link_libraries(permission_manager_plugin PUBLIC flutter_wrapper_plugin)

target_compile_definitions(permission_manager_plugin PUBLIC FLUTTER_PLUGIN_IMPL)
