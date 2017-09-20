import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import TDocument 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    anchors.fill: parent

    property double total: 0.0
    property bool isNew: true

    property TDocument pDocument

    function isValid()
    {
        if ((cbCash.checked && txtCash.text == "")
                || (cbCheck.checked && txtCheck.text == "")
                || (cbCard.checked && txtCard.text == "")
                || (cbVirman.checked && txtVirman.text == ""))
            return false;

        return true;
    }

    function getPayment(isChecked, value)
    {
        if (isChecked)
            return JsCommon.setDecimalPoint(value);
        else
            return -1;
    }

    function addNote()
    {
        var note = "";
        if (mSettings.noteCashier)
        {
            note += "#{0} {1}".replace('{0}', mCashier.id).replace('{1}', mCashier.name);
        }

        if (mSettings.notePredefined != "" || txtNapomena.text != "")
        {
            note += "\n";
            note += (mSettings.notePredefined != "") ?
                        mSettings.notePredefined : txtNapomena.text;
        }
        pDocument.note = note;
    }

    function addPayment()
    {
        pDocument.cash = getPayment(cbCash.checked, txtCash.text);
        pDocument.check = getPayment(cbCheck.checked, txtCheck.text);
        pDocument.card = getPayment(cbCard.checked, txtCard.text);
        pDocument.transferOrder = getPayment(cbVirman.checked, txtVirman.text);
    }

    function printReceipt()
    {
        var result = receiptCommon.receiptPrint(pDocument, receiptItemCommon.getReceiptItemList(),
                                                 receiptCommon, isNew, false);

        if (0 == result)
        {
            stackView.__currentItem._newReceipt();
            root.destroy();
        }
        else
        {
            JsCommon.checkErrorCode(result);
        }
    }

    Component.onCompleted:
    {
        toolbar.enabled = false;
    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    PropertyAnimation { target: root; property: "opacity";
                                  duration: 400; from: 0; to: 1;
                                  easing.type: Easing.InOutQuad ; running: true }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6

        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        width: 400
        height: 600
        color: "lightgrey"
        radius: 10
        anchors.centerIn: parent

        Column{
            spacing: 10
            anchors.centerIn: parent

            Text {
                height: 40
                width: 300
                id: txtTitle
                text: qsTr("PLAĆANJE")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                height: 40
                width: 300
                id: txttotal
                text: qsTr("Ukupno:") + " " + Number(total.toFixed(2)).toLocaleString(Qt.locale())
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Column {
                spacing: 10

                RowLayout {
                    spacing: 10
                    MyCheckBox
                    {
                        id: cbCash
                        width: 150
                        textColor: "black"
                        text: qsTr("Gotovina")
                        isSmall: true
                        checked: true
                    }
                    MyTextField {
                        id: txtCash
                        width: 150
                        text: JsCommon.setDecimalPlaces(0, 2)
                        validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        isSmall: true
                        isEnabled: cbCash.checked
                        isValid: (isEnabled && text != "")
                        onDonePressed: Qt.inputMethod.hide()
                    }
                }

                RowLayout {
                    spacing: 10
                    MyCheckBox
                    {
                        id: cbCheck
                        width: 150
                        textColor: "black"
                        text: qsTr("Ček")
                        isSmall: true
                    }
                    MyTextField {
                        id: txtCheck
                        width: 150
                        text: JsCommon.setDecimalPlaces(0, 2)
                        validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        isSmall: true
                        isEnabled: cbCheck.checked
                        isValid: (isEnabled && text != "")
                        onDonePressed: Qt.inputMethod.hide()
                    }
                }
                RowLayout {
                    spacing: 10
                    MyCheckBox
                    {
                        id: cbCard
                        width: 150
                        textColor: "black"
                        text: qsTr("Kartica")
                        isSmall: true
                    }
                    MyTextField {
                        id: txtCard
                        width: 150
                        text: JsCommon.setDecimalPlaces(0, 2)
                        validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        isSmall: true
                        isEnabled: cbCard.checked
                        isValid: (isEnabled && text != "")
                        onDonePressed: Qt.inputMethod.hide()
                    }
                }
                RowLayout {
                    spacing: 10
                    MyCheckBox
                    {
                        id: cbVirman
                        width: 150
                        textColor: "black"
                        text: qsTr("Virman")
                        isSmall: true
                    }
                    MyTextField {
                        id: txtVirman
                        width: 150
                        text: JsCommon.setDecimalPlaces(0, 2)
                        validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        isSmall: true
                        isEnabled: cbVirman.checked
                        isValid: (isEnabled && text != "")
                        onDonePressed: Qt.inputMethod.hide()
                    }
                }
            }
            TextArea
            {
                id: txtNapomena
                width: 310
                height: 100
                font.pixelSize: 20
                text: ""
                wrapMode: TextEdit.WrapAnywhere
                visible: (mSettings.notePredefined == "")
                Keys.onReturnPressed: Qt.inputMethod.hide()
            }

            Row {
                spacing: 10
                Rectangle {
                    height: 50
                    width: 150
                    color: mousePrint.pressed ? mStyle.colorButtonPressed : mStyle.colorButton

                    MouseArea {
                        id: mousePrint
                        anchors.fill: parent;
                        onClicked:
                        {
                            if (isValid())
                            {
                                addNote();
                                addPayment();
                                printReceipt();
                            }
                            else
                            {
                                toast.show(qsTr("Podaci nisu validni!"));
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Štampaj")
                        color: mousePrint.pressed ? mStyle.colorButtonTextPressed : mStyle.colorButtonText
                        font.pixelSize: 24
                    }
                }
                Rectangle {
                    height: 50
                    width: 150
                    color: mouseCancel.pressed ? mStyle.colorButtonPressed : mStyle.colorButton
                    MouseArea {
                        id: mouseCancel
                        anchors.fill: parent;
                        onClicked: {
                            root.destroy()
                            }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Odustani")
                        color: mouseCancel.pressed ? mStyle.colorButtonTextPressed : mStyle.colorButtonText
                        font.pixelSize: 24
                    }
                }
            }
        }
    }
}
