import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    property string _name : "payinout"

    width: parent.width
    height: parent.height

    property double cash: 0
    property double check: 0
    property double card: 0
    property double transfer: 0

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function parseAmounts()
    {
        if (txtCash.text != "")
        {
            root.cash = JsCommon.setDecimalPoint(txtCash.text);
        }
        if (txtCheck.text != "")
        {
            root.check = JsCommon.setDecimalPoint(txtCheck.text);
        }
        if (txtCard.text != "")
        {
            root.card = JsCommon.setDecimalPoint(txtCard.text);
        }
        if (txtTransfer.text != "")
        {
            root.transfer = JsCommon.setDecimalPoint(txtTransfer.text);
        }

    }

    function _payIn()
    {
        parseAmounts();

        var res = 0;
        if (root.cash > 0)
        {
            res = common.tflCashInOut(1, root.cash);
            JsCommon.checkErrorCode(res);
        }
        if (root.check > 0)
        {
            res = common.tflCheckInOut(1, root.check);
            JsCommon.checkErrorCode(res);
        }
        if (root.card > 0)
        {
            res = common.tflCardInOut(1, root.card);
            JsCommon.checkErrorCode(res);
        }
        if (root.transfer > 0)
        {
            res = common.tflTransferInOut(1, root.transfer);
            JsCommon.checkErrorCode(res);
        }
    }

    function _payOut()
    {
        parseAmounts();

        var res = 0;
        if (root.cash > 0)
        {
            res = common.tflCashInOut(0, root.cash);
            JsCommon.checkErrorCode(res);
        }
        if (root.check > 0)
        {
            res = common.tflCheckInOut(0, root.check);
            JsCommon.checkErrorCode(res);
        }
        if (root.card > 0)
        {
            common.tflCardInOut(0, root.card);
            JsCommon.checkErrorCode(res);
        }
        if (root.transfer > 0)
        {
            common.tflTransferInOut(0, root.transfer);
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
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtCash
                    label: qsTr("Gotovina")
                    text: Number(0.00).toLocaleString(Qt.locale())
                    validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    onDonePressed: txtCheck.setFocus()
                }
                MyTextFieldH {
                    id: txtCheck
                    label: qsTr("Ček")
                    text: Number(0.00).toLocaleString(Qt.locale())
                    validator:  DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    onDonePressed: txtCard.setFocus()
                }
                MyTextFieldH {
                    id: txtCard
                    label: qsTr("Kartica")
                    text: Number(0.00).toLocaleString(Qt.locale())
                    validator:  DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    onDonePressed: txtTransfer.setFocus()
                }
                MyTextFieldH {
                    id: txtTransfer
                    label: qsTr("Virman")
                    text: Number(0.00).toLocaleString(Qt.locale())
                    validator:  DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }
}
