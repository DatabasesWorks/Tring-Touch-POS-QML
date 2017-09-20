import QtQuick 2.9
import QtQuick.Controls 1.4

import TDocumentItem 1.0
import TReceiptItemCommon 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root
    width: parent.width
    height: parent.height

    property string _name : "receiptitemedit"

    property double quantity: 0
    property double discount: 0

    property TReceiptItemCommon pReceiptItemCommon
    property TDocumentItem pDocumentItem

    function _save()
    {
        if (isValid())
        {
            quantity = JsCommon.setDecimalPoint(txtIzlaz.text);
            discount = JsCommon.setDecimalPoint(txtDiscount.text);

            pReceiptItemCommon.updateReceiptItem(pDocumentItem, quantity, discount);

            stackView.pop({immediate: true});
        }
    }

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function isValid()
    {
        return (txtIzlaz.text != "" && txtIzlaz.text != "0"
                && txtDiscount.text != "");
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.margins: 20
        color: mStyle.colorAppBackground

        Flickable {
            id: flickArea
            width: root.width; height: root.height
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: main.width; contentHeight: main.height * 1.5
            flickableDirection: Flickable.VerticalFlick
            clip: true

        Column {
            id: main
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtIzlaz
                    label: qsTr("Količina")
                    width: parent.width - 40
                    text: JsCommon.setDecimalPlaces(pDocumentItem.output, 3)
                    validator: DoubleValidator {bottom: 0; decimals: 3; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    isValid: (text != "" && text != "0")
                    onDonePressed: txtDiscount.setFocus()
                 }
                MyTextFieldH {
                    id: txtDiscount
                    label: qsTr("Rabat (%)")
                    width: parent.width - 40
                    text: JsCommon.setDecimalPlaces(pDocumentItem.discountP, 2)
                    validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    isValid: (text != "")
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }

}
