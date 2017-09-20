import QtQuick 2.9

Item {
    id: checkbox
    height: isSmall ? 40 : 50

    property alias label: fieldLabel.text
    property alias textColor : fieldLabel.color
    property alias borderColor : rect.color
    property bool isSmall: false
    property bool checked // required variable
    property int mark: 30

    Row
    {
        anchors.fill: parent
        spacing: 10

        Text {
            id: fieldLabel
            color: "white"
            font.pixelSize: 20
            width: (text == "") ? 0 : 180
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            font.capitalization: Font.AllUppercase
        }

        Rectangle {
            id: rect
            width: parent.height
            height: parent.height
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
    }
}
