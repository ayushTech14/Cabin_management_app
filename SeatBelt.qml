import QtQuick 2.15
import QtQuick.Controls 2.15
import MyApp 1.0  // Import the C++ class

Rectangle {
    width: 600
    height: 400
    color: "transparent"

    property string imgpath: "file:///home/lab/Pictures/AirBus/airbusapplication/asset/"
      // property string imgpath: "file:///usr/Airbus_assets/"

    ListModel {
        id: seatModel
        ListElement { occupied: false; buckled: false }
        ListElement { occupied: false; buckled: false }
        ListElement { occupied: false; buckled: false }
        ListElement { occupied: false; buckled: false }
    }

    TcpServer {
        id: tcpServer
        onJsonReceived: function(jsonString) {
            try {
                var json = JSON.parse(jsonString);
                console.log("Received JSON: " + JSON.stringify(json, null, 2));

                for (var i = 0; i < seatModel.count; i++) {
                    var seatKey = "seat" + (i + 1);
                    var seatbeltKey = "seat" + (i + 1) + "_belt";

                    if (json.hasOwnProperty(seatKey) && json.hasOwnProperty(seatbeltKey)) {
                        let occupiedState = (json[seatKey] === "occupied");
                        let buckledState = (json[seatbeltKey] === "buckled");

                        console.log(`Updating seat ${i + 1}: Occupied=${occupiedState}, Buckled=${buckledState}`);

                        // ✅ Correct method to update ListModel entries
                        seatModel.set(i, {
                            occupied: occupiedState,
                            buckled: buckledState
                        });
                    }
                }
            } catch (e) {
                console.error("JSON parsing error: " + e);
            }
        }
    }

    Component.onCompleted: {
        console.log("Starting server...");
        console.log("Image Path Test: " + imgpath + "green.png");  // ✅ Debug image path
        tcpServer.startServer(5100);
    }

    Column {
        spacing: 20
        anchors.centerIn: parent

        Text {
            text: "Seatbelt Status"
            font.pixelSize: 24
            color: "white"
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: seatModel
                delegate: Rectangle {
                    width: 150
                    height: 200
                    color: model.occupied ? "#262626" : "#404040"
                    border.color: "white"
                    border.width: 2
                    radius: 10

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        // ✅ Seat Occupancy Text
                        Text {
                            text: model.occupied ? "Occupied" : "Not Occupied"
                            color: "white"
                            font.pixelSize: 18
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // ✅ Seatbelt Status Image (Red if not buckled, Green if buckled)
                        Image {
                            id: seatbeltImage
                            width: 100
                            height: 100
                            fillMode: Image.PreserveAspectFit
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: model.occupied  // ✅ Only show image if occupied
                            source: model.occupied
                                ? (model.buckled ? imgpath + "green.png" : imgpath + "red.png")
                                : ""
                        }

                        // ✅ Seatbelt Text Indicator
                        Text {
                            text: model.buckled ? "Buckled" : "Not Buckled"
                            color: model.buckled ? "green" : "red"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}
