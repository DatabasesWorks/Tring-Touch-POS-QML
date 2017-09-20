import QtQuick 2.9

Rectangle {
    id: root
    color: "transparent"
    width: parent.width
    height: 88

    property alias title: titleItem.text
    property alias subtitle: subtitleItem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: mouse.pressed ? "#11ffffff" : "transparent"
        //visible: mouse.pressed

        Text {
            id: titleItem
            //color: "white"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 15
            width: parent.width - 30
            elide: Text.ElideRight
        }
        Text {
            id: subtitleItem
            //color: "white"
            font.pixelSize: 20
            anchors.top: titleItem.bottom
            anchors.left: parent.left
            anchors.leftMargin: 15
            width: parent.width - 30
            elide: Text.ElideRight
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: subtitleItem.bottom
            //anchors.leftMargin: 15
            //anchors.rightMargin: 15
            anchors.topMargin: 10
            height: 1
            color: "#424246"
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked:        {
            root.clicked();
        }
    }
}
