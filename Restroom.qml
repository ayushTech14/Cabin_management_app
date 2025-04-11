import QtQuick 2.15
import QtQuick.Controls 2.15
import MyApp 1.0  // ✅ Import the C++ class

Rectangle {
    width: 1920
    height: 1080
    color: "transparent"

    property string imgpath: "file:///home/lab/Pictures/AirBus/airbusapplication/asset/"
      // property string imgpath: "file:///usr/Airbus_assets/"

    // ✅ Create TCP Server
    TcpServer {
        id: tcpServer
        onJsonReceived: function(jsonString) {
            var json = JSON.parse(jsonString);
            restroom1Available.visible = (json.restroom1 === "available");
            restroom1Occupied.visible = (json.restroom1 === "occupied");
            restroom2Available.visible = (json.restroom2 === "available");
            restroom2Occupied.visible = (json.restroom2 === "occupied");
        }
    }

    // ✅ Start server when UI loads
    Component.onCompleted: {
        console.log("Starting server...");
        tcpServer.startServer(5000);
    }

    Column {
        spacing: 40
        anchors.centerIn: parent

        Row {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            // Restroom 1
            Rectangle {
                width: 250
                height: 200
                radius: 20
                color: "#333333"
                border.color: "white"
                border.width: 2

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "Restroom 1"
                        font.pixelSize: 24
                        color: "white"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: 20
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: restroom1Available
                            source: imgpath + "available.png"
                            width: 80
                            height: 80
                            visible: true
                        }

                        Image {
                            id: restroom1Occupied
                            source: imgpath + "occupied.png"
                            width: 80
                            height: 80
                            visible: false
                        }
                    }
                }
            }

            // Restroom 2
            Rectangle {
                width: 250
                height: 200
                radius: 20
                color: "#333333"
                border.color: "white"
                border.width: 2

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "Restroom 2"
                        font.pixelSize: 24
                        color: "white"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: 20
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: restroom2Available
                            source: imgpath + "available.png"
                            width: 80
                            height: 80
                            visible: true
                        }

                        Image {
                            id: restroom2Occupied
                            source: imgpath + "occupied.png"
                            width: 80
                            height: 80
                            visible: false
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        id: statusrect
        height: 250
        width: 400
        radius: 40
        anchors.bottom: parent.bottom
        color: "#092141"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                id: name
                text: qsTr("Restroom Status")
                color: "white"
                font.bold: true
                font.pixelSize: 30
                anchors.top: statusrect.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: redrect
                    height: 50
                    width: 50
                    radius: 10
                    color: "red"

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: occ
                    text: qsTr("Occupied")
                    font.pixelSize: 30
                    color: "white"
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: greenrect
                    height: 50
                    width: 50
                    radius: 10
                    color: "green"

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: vacant
                    text: qsTr("Available")
                    font.pixelSize: 30
                    font.bold: true
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }


}

