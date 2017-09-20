import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import TDocument 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root
    anchors.fill: parent

    property string title: ""
    property string text: ""
    property color buttonColor: "#32b4e5"

    function isValid()
    {
        return true;
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
        height: parent.height - 20
        color: "lightgrey"

        radius: 10
        anchors.centerIn: parent

        Column{
            anchors.centerIn: parent

            Text {
                height: 50
                width: 300
                id: txtTitle
                text: root.title
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            Row {
                 height: 10
                 width: 300
            }

            TextArea
            {
                width: 310
                height: 400
                font.pixelSize: 20
                text: root.text
                wrapMode: TextEdit.WrapAnywhere
                readOnly: true
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
                    color: mousePrint.pressed ? "white" : root.buttonColor

                    MouseArea {
                        id: mousePrint
                        anchors.fill: parent;
                        onClicked:
                        {
                            if (0 == stackView.__currentItem._printText(root.text))
                                root.destroy();
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Štampaj")
                        color: mousePrint.pressed ? "lightgrey" : "white"
                        font.pixelSize: 24
                    }
                }
                Rectangle {
                    height: 50
                    width: 150
                    color: mouseCancel.pressed ? "white" : root.buttonColor
                    MouseArea {
                        id: mouseCancel
                        anchors.fill: parent;
                        onClicked: root.destroy()
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Odustani")
                        color: mouseCancel.pressed ? "lightgrey" : "white"
                        font.pixelSize: 24
                    }
                }
            }
        }
    }
}
