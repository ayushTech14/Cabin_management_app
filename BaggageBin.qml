import QtQuick 2.15
import QtQuick.Controls 2.15
import MyApp 1.0  // ✅ Import C++ TCP Server

Rectangle {
    width: 800
    height: 500
    color: "transparent"

   property string imgpath: "file:///home/lab/Pictures/AirBus/airbusapplication/asset/"
      // property string imgpath: "file:///usr/Airbus_assets/"

    ListModel {
        id: statusModel
        ListElement { status: "empty" }
        ListElement { status: "empty" }
        ListElement { status: "empty" }
        ListElement { status: "empty" }
    }

    TcpServer {
        id: tcpServer
        onJsonReceived: function(jsonString)  {
            try {
                var json = JSON.parse(jsonString);
                console.log("Received JSON in Second QML:", jsonString);

                if (json.hasOwnProperty("status") && Array.isArray(json.status) && json.status.length === 4) {
                    for (var i = 0; i < 4; i++) {
                        console.log("Updating seat", i + 1, "with status:", json.status[i]);
                        statusModel.set(i, { status: json.status[i] });
                    }
                } else {
                    console.log("⚠️ Invalid JSON format received");
                }
            } catch (e) {
                console.log("❌ JSON Parse Error:", e);
            }
        }
    }
    Component.onCompleted: {
        console.log("Starting server...");
        tcpServer.startServer(5050);
    }


    Column {
        spacing: 40
        anchors.centerIn: parent

        Row {
            spacing: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: statusModel
                delegate: Rectangle {
                    width: 180
                    height: 250
                    radius: 15
                    color: "#333333"
                    border.color: "white"
                    border.width: 2

                    Column {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "Seat " + (index + 1)
                            font.pixelSize: 20
                            color: "white"
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            spacing: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                            Image {
                                width: 80
                                height: 80
                                source: {
                                    var currentStatus = model.status;
                                    var imagePath = imgpath;

                                    if (currentStatus === "full") {
                                        imagePath += "red.png";
                                    } else if (currentStatus === "half") {
                                        imagePath += "yellow.png";
                                    } else {
                                        imagePath += "green.png";
                                    }

                                    return imagePath;
                                }
                            }

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
                Row {
                    spacing: 16
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: yellow
                        height: 50
                        width: 50
                        radius: 10
                        color: "yellow"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: half
                        text: qsTr("Half FIlled")
                        font.pixelSize: 30
                        font.bold: true
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

