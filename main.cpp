#include "MainPageButtonController.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqml.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MainPageButtonController* mainPageButtonController = new MainPageButtonController;
    qmlRegisterSingletonInstance("com.Comui521.MainPageButtonController", 1, 0, "MainPageButtonController", mainPageButtonController);

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
