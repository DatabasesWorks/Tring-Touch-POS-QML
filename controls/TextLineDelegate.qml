import QtQuick 2.9

Item {
    id: root
    width: parent.width
    //height: 68
    height: 50

    property alias text: textitem.text
    property color lineColor: "#32b4e5"
    signal clicked

    Text {
        id: textitem
        color: "white"
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width
        elide: Text.ElideRight

    }
    Rectangle {
        anchors.right: root.right
        anchors.left: root.left
        height: 1
        color: lineColor
    }
    MouseArea {
        anchors.fill:  root
        onClicked: root.clicked()
    }
}
