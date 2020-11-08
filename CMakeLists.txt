cmake_minimum_required(VERSION 3.11)

include(AddQtMacosDmg.cmake)

set(QT_MACOS_QT_ROOT ${QT_MACOS_QT_ROOT} CACHE STRING "Qt SDK root folder")
set(QT_MACOS_SOURCE_DIR ${QT_MACOS_SOURCE_DIR} CACHE STRING "add_qt_macos_dmg CMakeLists.txt folder")

set(QT_MACOS_CMAKE_FOUND ON CACHE BOOL "QtMacosCMake have been found" FORCE)
set(QT_MACOS_CMAKE_VERSION "1.0.0" CACHE STRING "QtMacosCMake version" FORCE)