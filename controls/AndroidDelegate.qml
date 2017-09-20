import QtQuick 2.9

Rectangle {
    id: root
    color: "transparent"
    width: parent.width
    height: 88

    property alias text: textitem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: mouse.pressed ? "#11ffffff" : "transparent"
        //visible: mouse.pressed

        Text {
            id: textitem
            color: "white"
            font.pixelSize: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            width: parent.width - 50
            elide: Text.ElideRight
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: textitem.bottom
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            anchors.topMargin: 25
            height: 1
            color: "#424246"
        }
    }

//    Image {
//        id: imgNext
//        anchors  {right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter}
//        source: "../images/navigation_next_item.png"
//    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked:        {
            root.clicked();
        }
    }
}
