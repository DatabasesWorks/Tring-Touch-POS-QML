import QtQuick 2.9
import QtQuick.Layouts 1.0

Item {
    id: checkbox
    height: isSmall ? 40 : 50
    //width: 150

    property alias text: txt.text
    property alias textColor : txt.color
    property alias borderColor : rect.color
    property bool isSmall: false
    property bool checked // required variable
    property int mark: 10

    RowLayout
    {
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: rect
            width: 30
            height: 30
            border.width: checkbox.focus ? 2 : 1
            border.color: "black"
            color: "transparent"
            radius: 0

            Image {
                id: imgChecked
                width: rect.width-mark; height: rect.height-mark;
                anchors.centerIn: parent
                source: checkbox.checked ? "../images/check.png" : ""
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                onClicked: checkbox.checked = !checkbox.checked
            }
        }
        Text
        {
            id: txt
            verticalAlignment: Text.AlignVCenter
            color: "white"
            font.pixelSize: isSmall ? 24 : 20
        }
    }
}
