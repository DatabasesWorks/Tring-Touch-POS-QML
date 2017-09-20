import QtQuick 2.9
import QtQuick.Controls 1.4

import TCustomer 1.0
import TDocument 1.0

import "../controls"

Item {
    id: root

    anchors.fill: parent

    property bool isNewCustomer : false

    property TDocument pDocument
    property TCustomer customer

    Component.onCompleted:
    {
        toolbar.enabled = false;
        customer = customerCommon.getCustomer(pDocument.customerId);

    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    function getCustomerInfo()
    {
        var customerInfo = "";
        if (customer != undefined)
        {
            customerInfo = customer.idc + "\n"
                        + customer.line1 + "\n"
                        + customer.line2 + "\n"
                        + customer.line3 + "\n"
                        + customer.line4;
        }
        return customerInfo;
    }

    function search(searchText)
    {
        listCustomer.model = customerCommon.getCustomers(searchText);
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
        id: recCustomerAdd
        width: 400
        height: 600
        color: "lightgrey"

        radius: 10
        anchors.centerIn: parent

        Column{
            spacing: 10
            anchors.centerIn: parent
            //anchors.margins: 10
            Text {
                height: 40
                width: 300
                id: txtTitle
                text: qsTr("KOMITENT")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            Item
            {
                width: 310
                height: 350

                Column{
                    anchors.fill: parent

                    /* search */
                    Search
                    {
                       width: parent.width
                       height: 50
                       lightBox: true
                       timerInterval: 100
                       onTimerEnded: search(inputText)
                    }
                    /* customer list */
                    Rectangle
                    {
                        width: parent.width
                        height: 140
                        anchors.rightMargin: 5
                        color: "transparent"
                        border.color: mStyle.colorBorderExpressed
                        border.width: 1

                        ListView {
                            id: listCustomer
                            clip: true
                            anchors.fill: parent
                            interactive: contentHeight > height

                            model: customerCommon.getCustomers("")

                            delegate: AndroidDelegateSmall {
                                 id:txtTest
                                 text:   model.modelData.line1
                                 onClicked:
                                 {
                                     customer = model.modelData;
                                 }
                             }
                        }
                    }
                    /* display selected customer */
                    Rectangle
                    {
                        width: parent.width
                        height: 160
                        color: "#bfbfbf"//"transparent"
                        border.color: mStyle.colorBorderExpressed
                        border.width: 1

                        Text {
                            id: txtCustomerInfo
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            width: parent.width
                            elide: Text.ElideRight
                            text: getCustomerInfo();
                        }
                    }
                }
            }
            Row {
                spacing: 10
                Rectangle {
                    height: 50
                    width: 150
                    color: mouseAdd.pressed ? mStyle.colorButtonPressed: mStyle.colorButton

                    MouseArea {
                        id: mouseAdd
                        anchors.fill: parent;
                        onClicked: {
                            if (customer != undefined)
                            {
                                pDocument.customerId = customer.id;
                                stackView.__currentItem._setReceiptInfo();
                                root.destroy();
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Dodaj")
                        color: mouseAdd.pressed ? mStyle.colorButtonTextPressed : mStyle.colorButtonText
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
