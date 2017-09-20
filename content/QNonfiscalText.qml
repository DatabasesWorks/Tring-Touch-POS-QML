import QtQuick 2.9
import QtQuick.Controls 1.4

import TItem 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "nonfiscaltext"

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function _print()
    {
        var pText = txtNonfiscal.text
        if (pText != "")
        {
            var res = common.tflNonfiscalText(pText);
            JsCommon.checkErrorCode(res);
        }
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.margins: 20
        color: mStyle.colorAppBackground

        Flickable {
        id: flickArea
        width: root.width; height: root.height
        interactive: contentHeight > height
        contentWidth: main.width; contentHeight: main.height * 1.5
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Column {
            id: main
            spacing: 20
                MyTextAreaH {
                    id: txtNonfiscal
                    label: qsTr("Nefiskalni tekst")
                    width: parent.width - 40
                    height: 300
                    text: ""
                    wrapMode: TextEdit.WrapAnywhere
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }
}

