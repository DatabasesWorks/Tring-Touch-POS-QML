import QtQuick 2.9

Item {
    id: container

    property string source: ""
    property color borderColor: "#32b4e5"
    signal clicked

    width: 50
    height: 50

    Rectangle {
        id: rectSmallButtom
        anchors.fill: parent
        color: mouseSmallButton.pressed ? Qt.darker("Gray", 1.5) : "transparent"
        border.color: container.borderColor
        border.width: 1

        Image {
            id: imgFav
            source: container.source
            width: parent.width - 2; height: parent.height - 2
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseSmallButton
            anchors.fill: parent
            onClicked: {
                container.clicked()
            }
        }
     }
}
