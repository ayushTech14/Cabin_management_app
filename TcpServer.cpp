#include "TcpServer.h"
#include <QDebug>

TcpServer::TcpServer(QObject *parent) : QObject(parent), server(new QTcpServer(this)), clientSocket(nullptr) {
    connect(server, &QTcpServer::newConnection, this, &TcpServer::newConnection);
}

TcpServer::~TcpServer() {
    server->close();
}

void TcpServer::startServer(int port) {
    if (server->listen(QHostAddress::Any, port)) {
        qDebug() << "Server started on port:" << port;
    } else {
        qDebug() << "Server failed to start:" << server->errorString();
    }
}

void TcpServer::newConnection() {
    clientSocket = server->nextPendingConnection();
    connect(clientSocket, &QTcpSocket::readyRead, this, &TcpServer::readData);
    qDebug() << "Client connected!";
}

void TcpServer::readData() {
    if (clientSocket) {
        QByteArray data = clientSocket->readAll();
        QString jsonData = QString::fromUtf8(data);
        emit jsonReceived(jsonData);
        qDebug() << "Received JSON:" << jsonData;
    }
}
