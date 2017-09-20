import QtQuick 2.9

import TDocumentItem 1.0

import "../controls"

Item {
    id: menuComponent

    anchors.fill: parent

    property color titleColor: "#32b4e5"
    property color textColor: "white"

    property int itemHeight: 64
    property string option: ""

    property var model: [
        { title: qsTr("Uredi"), option: "Edit" },
        { title: qsTr("Obriši"), option: "DeleteAll" },
    ]

    property TDocumentItem pDocumentItem

    PropertyAnimation { target: menuComponent; property: "opacity";
                                  duration: 400; from: 0; to: 1;
                                  easing.type: Easing.InOutQuad ; running: true }

    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6

        MouseArea {
            anchors.fill: parent
            onClicked: menuComponent.destroy()
        }
    }


    Rectangle {
        id: recMenu
        width: parent.width - 20
        height: itemHeight * 3
        radius: 10
        anchors.centerIn: parent

        Rectangle {
            id: recTitle
            anchors.top: recMenu.top;
            anchors.left: recMenu.left;
            anchors.right: recMenu.right
            height: menuComponent.itemHeight
            color: menuComponent.titleColor
            Text {
                id: txtTitle
                font.pixelSize: 20
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    topMargin: 4
                    bottomMargin: 4
                    leftMargin: 8
                    rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                color: menuComponent.textColor
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                text: pDocumentItem.name
            }
        }
        Rectangle {
            id: recList
            anchors.top: recTitle.bottom;
            anchors.left: recMenu.left;
            anchors.right: recMenu.right
            anchors.bottom: recMenu.bottom
            color: "gray"
            ListView {
                id: mainList
                anchors.fill: recList
                snapMode: ListView.SnapPosition
                interactive : false
                clip: true
                model: menuComponent.model//menuModel
                delegate: MenuDelegate {
                    property var item: model.modelData ? model.modelData : model
                    text:   item.title
                    onClicked: {
                        menuComponent.option = item.option
                        menuComponent.destroy();
                    }
                }
            }
        }
    }

    Component.onDestruction:
    {
        menuComponent.parent.selectedItem(pDocumentItem, menuComponent.option, true)
    }
}
