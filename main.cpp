#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "TcpServer.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
     qmlRegisterType<TcpServer>("MyApp", 1, 0, "TcpServer");
    TcpServer tcpServer;
    engine.rootContext()->setContextProperty("tcpClient", &tcpServer);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("airbusapplication", "Main");

    return app.exec();
}
