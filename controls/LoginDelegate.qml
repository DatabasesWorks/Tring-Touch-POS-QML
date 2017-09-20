import QtQuick 2.9

Item {
    id: root
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    height: 88

    property alias text: textitem.text
    signal clicked

    Rectangle {
        anchors.fill: root
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Image {
        anchors.left: root.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 20
        source: "../images/profile.png"
    }


    Text {
        id: textitem
        color: "white"
        font.pixelSize: 32
        text: modelData
        anchors.verticalCenter: root.verticalCenter
        anchors.left: root.left
        anchors.leftMargin: 120
    }

    Rectangle {
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 15
        height: 1
        color: "#424246"
    }

    Image {
        anchors.right: root.right
        anchors.rightMargin: 20
        anchors.verticalCenter: root.verticalCenter
        source: "../images/navigation_next_item.png"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
