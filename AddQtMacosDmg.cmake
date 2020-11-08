# find the Qt root directory
if (NOT Qt5Core_DIR)
    find_package(Qt5Core REQUIRED)
endif ()
get_filename_component(QT_MACOS_QT_ROOT "${Qt5Core_DIR}/../../.." ABSOLUTE)
message(STATUS "Found Qt for MacOS: ${QT_MACOS_QT_ROOT}")

set(QT_MACOS_QT_ROOT ${QT_MACOS_QT_ROOT})
set(QT_MACOS_SOURCE_DIR .)

set(QBC_REPOSITORY "https://github.com/OlivierLDff/QbcInstaller.git" CACHE STRING "Repository of Qbc")
set(QBC_TAG "master" CACHE STRING "Git Tag of Qbc")

include(FetchContent)

# Qbc
FetchContent_Declare(
        Qbc
        GIT_REPOSITORY ${QBC_REPOSITORY}
        GIT_TAG ${QBC_TAG}
        GIT_SHALLOW 1
)
FetchContent_MakeAvailable(Qbc)

include(CMakeParseArguments)

# define a function to create a MacOS DMG target
#
# example:
# add_qt_macos_dmg(my_app
#     NAME "MyApp"
#     QML_DIR "path/to/qmldir"
#     NO_PLUGINS
#     NO_STRIP
#     OVERWRITE_EXISTING
#     VERBOSE_LEVEL_DEPLOY 1
#     ALL
#)

function(add_qt_macos_dmg TARGET)

    set(QT_MACOS_OPTIONS ALL
            NO_PLUGINS
            NO_STRIP
            OVERWRITE_EXISTING
            )

    set(QT_MACOS_ONE_VALUE_ARG NAME
            QML_DIR
            VERBOSE_LEVEL_DEPLOY
            )
    set(QT_MACOS_MULTI_VALUE_ARG)
    # parse the function arguments
    cmake_parse_arguments(ARGMAC "${QT_MACOS_OPTIONS}" "${QT_MACOS_ONE_VALUE_ARG}" "${QT_MACOS_MULTI_VALUE_ARG}" ${ARGN})

    if (ARGMAC_VERBOSE_LEVEL_DEPLOY)
        message(STATUS "---- QtMacosCMake Configuration ----")
        message(STATUS "TARGET                : ${TARGET}")
        message(STATUS "APP_NAME              : ${ARGMAC_NAME}")
        message(STATUS "QML_DIR               : ${ARGMAC_QML_DIR}")
        message(STATUS "ALL                   : ${ARGMAC_ALL}")
        message(STATUS "NO_PLUGINS            : ${ARGMAC_NO_PLUGINS}")
        message(STATUS "NO_STRIP              : ${ARGMAC_NO_STRIP}")
        message(STATUS "OVERWRITE_EXISTING    : ${ARGMAC_OVERWRITE_EXISTING}")
        message(STATUS "VERBOSE_LEVEL_DEPLOY  : ${ARGMAC_VERBOSE_LEVEL_DEPLOY}")
        message(STATUS "---- End QtMacosCMake Configuration ----")
    endif () # ARGMAC_VERBOSE_LEVEL_DEPLOY

    # ────────── DEPLOY ─────────────────────────

    # define the application qml dirs
    if (NOT ARGMAC_QML_DIR)
        set(ARGMAC_QML_DIR ${QT_MACOS_QT_ROOT}/qml)
    endif ()
    set(QT_MACOS_APP_QML_DIR -qmldir ${ARGMAC_QML_DIR})

    if (ARGMAC_NO_PLUGINS)
        set(QT_MACOS_APP_NO_PLUGINS -no-plugins)
    endif ()

    if (ARGMAC_NO_STRIP)
        set(QT_MACOS_APP_NO_STRIP -no-strip)
    endif ()

    if (ARGMAC_OVERWRITE_EXISTING)
        set(QT_MACOS_APP_OVERWRITE_EXISTING -always-overwrite)
    endif ()

    if (ARGMAC_VERBOSE_LEVEL_DEPLOY)
        set(QT_MACOS_APP_VERBOSE_LEVEL_DEPLOY -verbose=3)
    endif ()

    if (ARGMAC_ALL)
        set(QT_MACOS_ALL ALL)
    endif ()

    # Create Custom Target
    add_custom_target(${TARGET}Deploy
            ${QT_MACOS_ALL}
            DEPENDS ${TARGET} ${ARGMAC_DEPENDS}
            COMMAND ${QT_MACOS_QT_ROOT}/bin/macdeployqt
            ${TARGET}.app
            -dmg
            ${QT_MACOS_APP_QML_DIR}
            ${QT_MACOS_APP_NO_PLUGINS}
            ${QT_MACOS_APP_NO_STRIP}
            ${QT_MACOS_APP_OVERWRITE_EXISTING}
            ${QT_MACOS_APP_VERBOSE_LEVEL_DEPLOY}
            COMMENT "call ${QT_MACOS_QT_ROOT}/bin/macdeployqt in folder $<TARGET_FILE_DIR:${TARGET}>"
            )
endfunction()
