import QtQuick 2.9

Item {
    id: root
    width: parent.width
    height: 32

    property alias text: textitem.text
    signal clicked

//    Rectangle {
//        anchors.fill: parent
//        color: "#11ffffff"
//        visible: mouse.pressed
//    }

    Text {
        id: textitem
        //color: "white"
        font.pixelSize: 24
        //text: modelData
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width - 50 //-margine
        elide: Text.ElideRight
    }

//    Rectangle {
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.margins: 15
//        height: 1
//        color: "#424246"
//    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
