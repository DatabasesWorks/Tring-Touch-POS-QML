import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import TDocument 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    anchors.fill: parent

    property TDocument pDocument

    function isValid()
    {
        return (txtTitle.text != "");
    }

    function getReceiptId()
    {
        pDocument.id = receiptCommon.getNewReceiptId();
    }

    function getReceiptInitTitle()
    {
        txtTitle.text = pDocument.id;
        txtTitle.forceActiveFocus();
    }

    function saveReceipt()
    {
        pDocument.title = txtTitle.text;

        var result = receiptCommon.receiptSave(pDocument, receiptItemCommon.getReceiptItemList(),
                                             receiptCommon);

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
        getReceiptId();
        getReceiptInitTitle();
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
                text: qsTr("NAZIV RAČUNA")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            MyTextField
            {
                id: txtTitle
                width: 310
                text: ""
                isValid: (text != "")
                onDonePressed: Qt.inputMethod.hide()
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
                                saveReceipt();
                            }
                            else
                            {
                                toast.show(qsTr("Podaci nisu validni!"));
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Snimi")
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
