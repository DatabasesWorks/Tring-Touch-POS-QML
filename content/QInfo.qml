import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    anchors.fill: parent

    property var model: [
        { title: qsTr("Verzija"), subtitle: common.getVersion() },
        { title: qsTr("Git commit"), subtitle: common.getGitCommit() }
    ]

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
                width: 350
                id: txtTitle
                text: qsTr("INFORMACIJE")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            ListView {
            id: mainList
            interactive: contentHeight > height
            model: root.model
            width: 350
            height: 400

            delegate: TitleSubtitleDelegate {
                property var item: model.modelData ? model.modelData : model
                title:   item.title
                subtitle:   item.subtitle
                }
            }

            Rectangle {
                height: 50
                width: 350
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
                    text: qsTr("OK")
                    color: mouseCancel.pressed ? mStyle.colorButtonTextPressed : mStyle.colorButtonText
                    font.pixelSize: 24
                }
            }
        }
    }
}
