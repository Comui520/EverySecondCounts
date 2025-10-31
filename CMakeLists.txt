cmake_minimum_required(VERSION 3.16)

project(EverySecondCounts VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appEverySecondCounts
    main.cpp
)

qt_add_qml_module(appEverySecondCounts
    URI EverySecondCounts
    VERSION 1.0
    QML_FILES
        Main.qml
        CommonPage.qml
        CountDown.qml
        ImageButton.qml
        MainPage.qml
        MainSection.qml
        RollingBlock.qml
    SOURCES
        MainPageButtonController.h MainPageButtonController.cpp
        RedirectInfoProvider.h RedirectInfoProvider.cpp
        TimeController.h TimeController.cpp
    RESOURCES
        assets/icons/countdown_ico.png
        assets/icons/start_ico.png
        assets/icons/pause_ico.png
        assets/icons/cancel_ico.png
        assets/icons/addCommonCountdown_ico.png
        assets/icons/confirm_ico.png
        assets/icons/delete_ico.png
        assets/audios/ring.mp3
        QML_FILES Theme.qml
        SOURCES
        SOURCES MyTime.h MyTime.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appEverySecondCounts PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appEverySecondCounts
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appEverySecondCounts
    PRIVATE Qt6::Quick
)
target_link_libraries(appEverySecondCounts PRIVATE Qt6::Core)
target_link_libraries(appEverySecondCounts PRIVATE Qt6::Multimedia)
target_link_libraries(appEverySecondCounts PRIVATE Qt6::Core)
target_link_libraries(appEverySecondCounts PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appEverySecondCounts
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
