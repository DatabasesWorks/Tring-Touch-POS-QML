import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "duplicates"

    function setDateFieldsOpacity()
    {
        var id = model[cmbDocuments.currentIndex].id;

        if (txtNumber != null)
            txtNumber.isEnabled = (id == 0 || id == 1 || id == 3);
    }

    function isValid()
    {
        var id = model[cmbDocuments.currentIndex].id;

        if (!txtNumber.isEnabled)
            return true;
        else if (txtNumber.isEnabled && txtNumber.isValid)
            return true;
        else
            return false;
    }

    function _duplicate()
    {
        var res = 0;
        if(0 == model[cmbDocuments.currentIndex].id)
        {
            res = common.tflReceiptDuplicate(txtNumber.text);
            JsCommon.checkErrorCode(res);
        }
        if(1 == model[cmbDocuments.currentIndex].id)
        {
            res = common.tflReclaimReceiptDuplicate(txtNumber.text);
            JsCommon.checkErrorCode(res);
        }
        if(2 == model[cmbDocuments.currentIndex].id)
        {
            res = common.tflXReportDuplicate();
            JsCommon.checkErrorCode(res);
        }
        else if (3 == model[cmbDocuments.currentIndex].id)
        {
            res = common.tflZReportDuplicate(txtNumber.text);
            JsCommon.checkErrorCode(res);
        }
        else if (4 == model[cmbDocuments.currentIndex].id)
        {
            res = common.tflPeriodicalReportDuplicate();
            JsCommon.checkErrorCode(res);
        }
    }

    property var model: [
        { title: qsTr("Fiskalni račun"), id: 0 },
        { title: qsTr("Reklamirani račun"), id: 1 },
        { title: qsTr("Presjek stanja"), id: 2 },
        { title: qsTr("Dnevni izvještaj"), id: 3 },
        { title: qsTr("Periodični izvještaj"), id: 4 }
    ]

    function _close()
    {
        stackView.pop({immediate: true});
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
            width: parent.width
            spacing: 20

                MyComboBoxH {
                    id: cmbDocuments
                    label: qsTr("Tip izvještaja")
                    width: parent.width - 40
                    model: root.model
                    textRole: "title"
                    currentIndex: 0
                    onIndexChanged: {
                        setDateFieldsOpacity();
                    }
                }
                MyTextFieldH {
                    id: txtNumber
                    label: qsTr("Broj dokumenta")
                    text: "1"
                    width: parent.width - 40
                    validator: IntValidator {bottom: 1}
                    inputMethodHints: Qt.ImhPreferNumbers
                    isValid: (visible && text != "" && text != "0")
                    onDonePressed: Qt.inputMethod.hide()
                }

                move: Transition {
                    NumberAnimation { properties: "x,y"; duration: 80 }
                }
            }
        }
    }
}
