import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    visible: true
    width: 1920
    height: 1080


    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#001a3d" }
            GradientStop { position: 1.0; color: "#004080" }
        }

        // Navigation Bar
        Rectangle {
            id: navBar
            width: parent.width
            height: parent.height * 0.1
            color: "#003366"
            anchors.top: parent.top

            Row {
                id: tabBar
                spacing: 100
                anchors.centerIn: parent

                function updateTab(selectedTab) {
                    restroomBtn.checked = (selectedTab === "Restroom.qml")
                    seatBeltBtn.checked = (selectedTab === "SeatBelt.qml")
                    baggageBinBtn.checked = (selectedTab === "BaggageBin.qml")
                }

                Button {
                    id: restroomBtn
                    text: "Restroom"
                    checkable: true
                    checked: true
                    font.pixelSize: 22
                    background: Rectangle { color: restroomBtn.checked ? "#0066cc" : "transparent"; radius: 20 }
                    onClicked: {
                        pageLoader.source = "Restroom.qml"
                        tabBar.updateTab("Restroom.qml")
                    }
                }

                Button {
                    id: seatBeltBtn
                    text: "Seat Belt"
                    checkable: true
                    font.pixelSize: 22
                    background: Rectangle { color: seatBeltBtn.checked ? "#0066cc" : "transparent"; radius: 20 }
                    onClicked: {
                        pageLoader.source = "SeatBelt.qml"
                        tabBar.updateTab("SeatBelt.qml")
                    }
                }

                Button {
                    id: baggageBinBtn
                    text: "Baggage Bin"
                    checkable: true
                    font.pixelSize: 22
                    background: Rectangle { color: baggageBinBtn.checked ? "#0066cc" : "transparent"; radius: 20 }
                    onClicked: {
                        pageLoader.source = "BaggageBin.qml"
                        tabBar.updateTab("BaggageBin.qml")
                    }
                }
            }
        }

        // Seat Map Image Section
     /*   Image {
            id: seatMap
            source: "file:///home/lab/QtProjects/AirBus/Airbus_assets/flight.png"
            width: parent.width * 0.6
            height: parent.height * 0.5
            anchors.top: navBar.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }*/

        // Page Loader Section
        Loader {
            id: pageLoader
            width: parent.width
            height: parent.height
            anchors.top: seatMap.bottom
            anchors.topMargin: parent.height * 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            source: "Restroom.qml" // Default page
        }

        /*// Home Button
        Button {
            id: homeButton
            text: "Home"
            width: 140
            height: 60
            font.bold: true
            font.pixelSize: 24
            background: Rectangle {

                radius: 20
            }
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 40
            onClicked: {
                pageLoader.source = "Main.qml"
            }
        }
        */
    }
}
