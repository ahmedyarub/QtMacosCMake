# Qt MacOS CMake

## What it is

This project provide a CMake macro to help you deploy Qt application on MacOS. It will generate a deploy target that creates a .dmg for your .app bundle.

* `macdeployqt` to deploy frameworks and qml. Documentation is available [here](https://doc.qt.io/qt-5/macos-deployment.html).

This project is conceptually based on the great [Olivier Le Doeuff](https://github.com/OlivierLDff/QtWindowsCMake).

## How to use it

### How to integrate it to your CMake configuration

All you have to do is to call the ```add_qt_macos_dmg``` macro to create a new target that will create the MacOS Deployment Targets.

```cmake
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    add_executable(MyApp MACOSX_BUNDLE ${MYAPP_SRCS})
	
    FetchContent_Declare(
            QtWindowsCMake
            GIT_REPOSITORY "https://github.com/ahmedyarub/QtMacosCMake"
            GIT_TAG        master
        )
    FetchContent_MakeAvailable(QtMacosCMake)
    add_qt_macos_dmg(MyApp)
ENDIF()
```

The you can simply run

```bash
make MyAppDeploy
```

Of course, ```add_qt_macos_dmg``` accepts more options, see below for the detail.

### How to run CMake

```cmake
add_qt_macos_dmg(my_app
    NAME "MyApp"
    QML_DIR "path/to/qmldir"
    NO_PLUGINS
    NO_STRIP
    OVERWRITE_EXISTING
    VERBOSE_LEVEL_DEPLOY 1
    ALL
)
```

Here is the full list of possible arguments:

## Contact

* Ahmed Yarub Hani Al Nuaimi: ahmedyarub@yahoo.com