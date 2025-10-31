#include "MainPageButtonController.h"
#include "TimeController.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqml.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MainPageButtonController* mainPageButtonController = new MainPageButtonController;
    qmlRegisterSingletonInstance("com.Comui520.MainPageButtonController", 1, 0, "MainPageButtonController", mainPageButtonController);

    TimeController* timeController = new TimeController;
    timeController->loadCommonCountdowns();
    qmlRegisterSingletonInstance("com.Comui520.TimeController", 1, 0, "TimeController", timeController);

    qmlRegisterSingletonType(QUrl("qrc:/qt/qml/EverySecondCounts/Theme.qml"),"com.Comui520.Theme", 1, 0, "Theme");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    QObject::connect(&app, &QCoreApplication::aboutToQuit, timeController, &TimeController::saveCommonCountdowns);
    engine.loadFromModule("EverySecondCounts", "Main");

    return app.exec();
}
