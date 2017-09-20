import QtQuick 2.9
import QtQuick.Controls 1.4

import "../style"

Item {
    height: isSmall ? 40 : 50

    property alias model: group.model
    property alias textRole: group.textRole
    property alias currentIndex: group.currentIndex
    property alias currentText: group.currentText
    property bool isSmall: false
    property bool isValid: true

    signal indexChanged()
    signal focusGet()

    ComboBox {
        id: group
        anchors.fill: parent
        style: (isValid) ? mStyle.comboBoxValid : mStyle.comboBoxInvalid
        //style: ComboBoxStyle{}

        onCurrentIndexChanged: indexChanged();

        onFocusChanged: if (focus) focusGet();
    }
}
