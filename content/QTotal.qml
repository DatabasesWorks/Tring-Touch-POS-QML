import QtQuick 2.9

import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    height: 60

    property double total: 0.0

    Rectangle {
        id: rectTotalPrikaza
        anchors.fill: parent
        color: "transparent"

        border.color: mStyle.colorBorderExpressed
        border.width: 1

        Text {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 5
            anchors.rightMargin: 10
            color: mStyle.colorLabelText
            text: qsTr("Ukupno")
            font.pixelSize: 11
        }
        Text {
            id: txtTotal
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 5
            anchors.rightMargin: 10
            anchors.left: parent.left
            color: mStyle.colorLabelText
            text: JsCommon.setDecimalPlaces(total, 2) + " " + qsTr("KM")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight

            onTextChanged: bounceAnimation.start()
        }
     }

    SequentialAnimation {
        id: bounceAnimation
        loops: 1
        PropertyAnimation {
            target: txtTotal
            properties: "font.pixelSize"
            from: 28
            to: 32
            duration: 100
        }
        PropertyAnimation {
            target: txtTotal
            properties: "font.pixelSize"
            from: 32
            to: 28
            duration: 100
        }
    }
}
