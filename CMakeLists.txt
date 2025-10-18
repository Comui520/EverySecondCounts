cmake_minimum_required(VERSION 3.16)

project(EverySecondCounts VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
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
        QML_FILES CommonPage.qml
        QML_FILES CountDown.qml
        QML_FILES ImageButton.qml
        QML_FILES MainPage.qml
        QML_FILES MainSection.qml
        SOURCES MainPageButtonController.h MainPageButtonController.cpp
        SOURCES RedirectInfoProvider.h RedirectInfoProvider.cpp
        RESOURCES assets/icons/countdown_ico.png
        RESOURCES resources.qrc
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
target_link_libraries(appEverySecondCounts PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appEverySecondCounts
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
