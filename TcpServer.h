#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <QTcpSocket>
#include <QObject>

class TcpServer : public QObject {
    Q_OBJECT
public:
    explicit TcpServer(QObject *parent = nullptr);
    ~TcpServer();

    Q_INVOKABLE void startServer(int port);

signals:
    void jsonReceived(QString jsonData);

private slots:
    void newConnection();
    void readData();

private:
    QTcpServer *server;
    QTcpSocket *clientSocket;
};

#endif // TCPSERVER_H
