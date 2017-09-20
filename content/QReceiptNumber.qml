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

    property TDocument pDocument

    Component.onCompleted:
    {
        toolbar.enabled = false;
        txtFiscalNumber.forceActiveFocus();

    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    function isValid()
    {
        return (txtFiscalNumber.text != "" && txtReclaimNumber.text != ""
                && txtTotal.text != "")
    }

    function prepare()
    {
        pDocument.fiscalNumber = txtFiscalNumber.text;
        pDocument.reclaimedNumber = txtReclaimNumber.text;
        pDocument.total = JsCommon.setDecimalPoint(txtTotal.text);
    }

    function updateReceipt()
    {
        var result = receiptCommon.receiptNumberSave(pDocument, receiptCommon);

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
        height: parent.height - 20
        color: "lightgrey"

        radius: 10
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent

            Text {
                height: 50
                width: 300
                id: txtTitle
                text: qsTr("UPIS FISKALNOG BROJA")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Row {
                 height: 10
                 width: 300
            }
            Row {
                spacing: 10
                Text {
                    height: 40
                    width: 150
                    text: qsTr("BF:") + " "
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }
                MyTextField {
                    id: txtFiscalNumber
                    width: 150
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers;
                    isSmall: true
                    isValid: (text != "")
                }
            }
            Row {
                height: 10
                width: 300
            }
            Row {
                spacing: 10
                Text {
                    height: 40
                    width: 150
                    text: qsTr("RF:") + " "
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }
                MyTextField {
                    id: txtReclaimNumber
                    text: "0"
                    width: 150
                    validator: IntValidator {bottom: 1;}
                    isSmall: true
                    isValid: (text != "")
                    onDonePressed: txtTotal.setFocus()
                }
            }
            Row {
                height: 10
                width: 300
            }
            Row {
                spacing: 10
                Text {
                    height: 40
                    width: 150
                    text: qsTr("Total:") + " "
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }
                MyTextField {
                    id: txtTotal
                    width: 150
                    text: JsCommon.setDecimalPlaces(pDocument.total, 2)
                    isSmall: true
                    validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    isValid: (text != "")
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
            Row {
                height: 20
                width: 300
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
                                updateReceipt();
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Snimi")
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
