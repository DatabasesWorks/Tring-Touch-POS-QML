import QtQuick 2.9
import QtQuick.Controls 1.4

import TDocument 1.0
import TReceiptItemCommon 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    anchors.fill: parent

    property double total: 0.0
    property var tReceiptItems
    property int fiscalReceiptId: -1
    property bool isReceiptReclaim: false
    property bool isCancel: false
    property bool isNew: true

    property TDocument pDocument
    property TDocument tDocument

    Component.onCompleted:
    {
        toolbar.enabled = false;

        if (0 == receiptItemCommon.getReceiptItemList().length)
        {
            isCancel = true;
            tDocument = receiptCommon.getNewReceipt();
        }
        txtFiscalNumber.forceActiveFocus();

    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    function getActiveReceipt()
    {
        if (isCancel)
            return tDocument;
        else
            return pDocument;
    }

    function getActiveReceiptItems()
    {
        if (isCancel)
            return tReceiptItems;
        else
            return receiptItemCommon.getReceiptItemList();
    }

    function isValid()
    {
        if (txtFiscalNumber.text == "" || txtFiscalNumber.text == "0")
        {
            toast.show(qsTr("Podaci nisu validni!"));
            return false;
        }

        fiscalReceiptId = receiptCommon.getFiscalReceiptId(txtFiscalNumber.text);
        if (isCancel && fiscalReceiptId == -1)
        {
            toast.show(qsTr("Račun ne postoji u bazi podataka!"));
            return false;
        }

        return true;
    }

    function prepare()
    {
        getActiveReceipt().fiscalNumber = txtFiscalNumber.text;
        if (txtCash.text != "")
            getActiveReceipt().cash = JsCommon.setDecimalPoint(txtCash.text);
        getActiveReceipt().card = -1;
        getActiveReceipt().check = -1;
        getActiveReceipt().transferOrder = -1;

        if (isCancel)
        {
            cancelReceipt();
        }
    }

    function cancelReceipt()
    {
        tReceiptItems = receiptItemCommon.getReceiptItemList(fiscalReceiptId);
    }

    function reclaim()
    {
        var result = receiptCommon.receiptPrint(getActiveReceipt(), getActiveReceiptItems(),
                                                 receiptCommon, isNew, true);

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
        id: recReclaim
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
                text: qsTr("REKLAMACIJA")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                height: 40
                width: 300
                id: txttotal
                //text: qsTr("Povrat:") + " " + root.total.toFixed(2)
                text: qsTr("Povrat:") + " " + Number(root.total.toFixed(2)).toLocaleString(Qt.locale())
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Row {
                spacing: 10
                Text {
                    height: 40
                    width: 150
                    text: qsTr("Broj racuna") + " "
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }
                MyTextField {
                    id: txtFiscalNumber
                    width: 150
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers;
                    text: getActiveReceipt().fiscalNumber
                    isSmall: true
                    isValid: (text != "" && text !="0")
                    onDonePressed: txtCash.setFocus()
                }
            }
            Row {
                spacing: 10
                Text {
                    height: 40
                    width: 150
                    text: qsTr("Gotovina") + " "
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }
                MyTextField {
                    id: txtCash
                    width: 150
                    text: JsCommon.setDecimalPlaces(0, 2)
                    validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers;
                    isSmall: true
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
            Row {
                spacing: 10
                Rectangle {
                    height: 50
                    width: 150
                    color: mouseReclaim.pressed ? mStyle.colorButtonPressed : mStyle.colorButton

                    MouseArea {
                        id: mouseReclaim
                        anchors.fill: parent;
                        onClicked: {
                            if (isValid())
                            {
                                prepare();
                                reclaim();
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Reklamiraj")
                        color: mouseReclaim.pressed ? mStyle.colorButtonTextPressed : mStyle.colorButtonText
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
