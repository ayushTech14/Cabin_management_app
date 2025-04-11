import QtQuick 6.2
import QtQuick.Controls 6.2

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
   property string imgpath: "file:///home/lab/Pictures/AirBus/airbusapplication/asset/"
    // property string imgpath: "file:///usr/Airbus_assets/"


    // Property to track current page
    property bool isHomeScreen: true

    Rectangle {
        id: rect1
        width: parent.width
        height: parent.height

        gradient: Gradient {
            GradientStop { position: 0.0007; color: "#030C21" }
            GradientStop { position: 0.2653; color: "#0D141F" }
            GradientStop { position: 0.9993; color: "#092141" }
        }

        // Top flight info bar
        Rectangle {
            width: parent.width * 0.16
            height: parent.height * 0.08
            radius: 20
            color: "#7FA6D9"
            anchors.top: parent.top
            anchors.margins: parent.height * 0.03

            Row {
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: "Bangalore"
                    font.bold: true
                    font.pixelSize: 16
                    color: "white"
                }

                Image {
                    source: imgpath + "flight.png"
                    width: 24
                    height: 24
                }

                Text {
                    text: "Hamburg"
                    font.bold: true
                    font.pixelSize: 16
                    color: "white"
                }
            }

            Text {
                text: "4h 32min"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
                color: "white"
            }
        }

        // Title (Only visible when isHomeScreen is true)
        Text {
            text: "Manage Cabin Experience"
            font.bold: true
            font.pixelSize: 28
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.15
            visible: isHomeScreen
        }

        // Logo (Only visible when isHomeScreen is true)
        Image {
            id: logo
            width: parent.width * 0.5
            height: parent.height * 0.4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height * -0.1
            fillMode: Image.PreserveAspectFit
            source: imgpath + "logo_blue.webp"
            visible: isHomeScreen
        }

        // Loader for dynamic pages
        Loader {
            id: pageLoader
            width: parent.width
            height: parent.height
            anchors.fill: parent
            source: "HomePage.qml" // Default page

            // Reset isHomeScreen when returning to HomePage.qml
            onLoaded: {
                isHomeScreen = (source === "HomePage.qml");
            }
        }

        // Menu Buttons (Only visible when isHomeScreen is true)
        Row {
            width: parent.width * 0.5
            height: parent.height * 0.22
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40
            visible: isHomeScreen

            // Orders Button
            Button {
                width: parent.width * 0.22
                height: parent.height
                background: Rectangle { radius: 20; color: "#66A3FF" }
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { source: imgpath + "orders.png"; width: 80; height: 80 }
                    Text { text: "Orders"; font.pixelSize: 18; color: "white" }
                }
                onClicked: {
                    pageLoader.source = "OrdersPage.qml";
                    isHomeScreen = false;
                }
            }

            // Galley Button
            Button {
                width: parent.width * 0.22
                height: parent.height
                background: Rectangle { radius: 20; color: "#5C85D6" }
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { source: imgpath + "galley.png"; width: 80; height: 80 }
                    Text { text: "Galley"; font.pixelSize: 18; color: "white" }
                }
                onClicked: {
                    pageLoader.source = "GalleyPage.qml";
                    isHomeScreen = false;
                }
            }

            // I-Cabin Button
            Button {
                width: parent.width * 0.22
                height: parent.height
                background: Rectangle { radius: 20; color: "#4D79C9" }
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { source: imgpath + "icabin.png"; width: 80; height: 80 }
                    Text { text: "I-Cabin"; font.pixelSize: 18; color: "white" }
                }
                onClicked: {
                    pageLoader.source = "ICabinPage.qml";
                    isHomeScreen = false;
                }
            }

            // Games Button
            Button {
                width: parent.width * 0.22
                height: parent.height
                background: Rectangle { radius: 20; color: "#3E66B3" }
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { source: imgpath + "game.png"; width: 80; height: 80 }
                    Text { text: "Games"; font.pixelSize: 18; color: "white" }
                }
                onClicked: {
                    pageLoader.source = "GamesPage.qml";
                    isHomeScreen = false;
                }
            }
        }

        // Back Button (Only visible when not on the home screen)
        Button {
            width: 150
            height: 50
            text: "Home"
            font.pixelSize: 18
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            visible: !isHomeScreen
            background: Rectangle {

                radius: 20
            }
            onClicked: {
                pageLoader.source = "HomePage.qml";
                isHomeScreen = true;
            }
        }
    }
}
