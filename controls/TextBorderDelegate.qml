import QtQuick 2.9

Rectangle {
    property int itemWidth: 100
    property int itemHeight: 50

    property color selectedColor: "#32b4e5"
    property color borderColor: "#32b4e5"
    property color textColor: "white"

    property alias text: txtitem.text
    signal clicked

    id: rec
    height: rec.itemHeight
    width: rec.itemWidth
    border.width: 1
    smooth: true
    border.color: rec.borderColor
    color: "transparent"

    Text {
        id:txtitem
        color: rec.textColor
        font.pixelSize: 20
        anchors.centerIn: parent
    }
    MouseArea {
       anchors.fill:  rec
       onClicked: rec.clicked()
//           list.currentIndex = index

    }
}
