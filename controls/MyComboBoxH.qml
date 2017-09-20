import QtQuick 2.9
import QtQuick.Controls 1.4

import "../style"

Item {
    height: isSmall ? 40 : 50

    property alias label: fieldLabel.text
    property alias model: field.model
    property alias textRole: field.textRole
    property alias currentIndex: field.currentIndex
    property alias currentText: field.currentText
    property alias field: field

    property bool isSmall: false
    property bool isValid: true

    signal indexChanged()
    signal focusGet()

    function setFocus()
    {
        field.forceActiveFocus();
    }

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
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.capitalization: Font.AllUppercase
        }

        ComboBox {
            id: field
            width: parent.width - fieldLabel.width - 10
            height: parent.height
            style: (isValid) ? mStyle.comboBoxValid : mStyle.comboBoxInvalid
            //style: ComboBoxInvalidStyle{}

            onCurrentIndexChanged: indexChanged();    

            onFocusChanged: if (focus) focusGet();

            onPressedChanged: pressed ? focus = true : focus = false;
        }
    }
}
