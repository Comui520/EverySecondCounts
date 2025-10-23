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
    qmlRegisterSingletonInstance("com.Comui520.TimeController", 1, 0, "TimeController", timeController);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("EverySecondCounts", "Main");

    return app.exec();
}
