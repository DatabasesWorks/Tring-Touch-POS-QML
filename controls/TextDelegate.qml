import QtQuick 2.9

Item {
    id: root

    property alias textTitle: txtitem.text
    property alias topSource: imgTop.source

    property bool istop: false

    property color selectedColor: "#32b4e5"
    property color textColor: "white"

    property int contentWidth: 0 //170
    property int contentHeight: 0 //150
    signal clicked
    signal topClicked

    width: contentWidth
    height: contentHeight

    Rectangle{
        id: rect
        anchors.fill: parent
        color: "transparent"
        border.color: root.selectedColor
        border.width: 1

        Text {

            id: txtitem
            width: rect.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: textColor
            font.pixelSize: 28
            elide: Text.ElideRight
            maximumLineCount: 1
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    Image {
        id: imgTop
        anchors.top: rect.top
        anchors.left: rect.left
        scale:  mouseTop.pressed ? 1.2 : 1.0
        width: 40; height: 40
        fillMode: Image.PreserveAspectFit

        MouseArea {
            id: mouseTop
            anchors.fill: parent
            hoverEnabled: true
            onPressAndHold: root.topClicked()
        }
    }
}
