import QtQuick 2.9

Item {
    id: container

    property int fontSize: 20
    property int itemIndex: -1
    property color fontColor: "white"
    property alias text: itemText.text
    signal clicked

    width: parent.width
    height: 64

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Qt.darker("Gray", 1.5)
        visible: mouseArea.pressed
    }

    Text {
        id: itemText
        font.pixelSize: container.fontSize
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            topMargin: 4
            bottomMargin: 4
            leftMargin: 8
            rightMargin: 8
            verticalCenter: container.verticalCenter
        }

        color: container.fontColor
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#32b4e5"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked:{
            container.clicked();
        }
    }
}
