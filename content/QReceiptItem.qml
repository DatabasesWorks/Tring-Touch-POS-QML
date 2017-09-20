import QtQuick 2.9
import QtQuick.Controls 1.4

import TDocumentItem 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    property color listTitleColor: "#047aa7"
    property color textColor: "white"
    property color lineColor: "#32b4e5"

    property bool menuEnabled: true

    property string number
    property double total: 0.0
    property double amount: 0.0

    property alias model: list.model
    property alias count: list.count

    signal selectedItem(TDocumentItem pDocumentItem, string option)

    Rectangle {
        id: listTitle
        color: listTitleColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top //title.bottom
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.topMargin: 1
        height: 50

        Text {
            color: textColor
            text: qsTr("Naziv")
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 14
            width: parent.width/2
            elide: Text.ElideRight
        }
        Text {
            color: textColor
            text: "#"
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15
            width: parent.width/2
            horizontalAlignment: Text.AlignRight
        }

        MouseArea {
            anchors.fill: parent
        }
    }

    ListView {
        id: list
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: listTitle.bottom
        anchors.bottom: parent.bottom
        orientation: ListView.Vertical
        interactive: contentHeight > height
        clip: true
        delegate: TextTextDelegate {
            title:  model.modelData.name
            number: JsCommon.setDecimalFormat(model.modelData.output)
            lineColor: lineColor
            onSlideRight: {
                if (menuEnabled)
                    root.selectedItem(model.modelData, "DeleteAll")
            }
            onSlideLeft: {
                if (menuEnabled)
                    root.selectedItem(model.modelData, "Edit")
            }
            onClickItem: {
                if (menuEnabled)
                    root.selectedItem(model.modelData, "DeleteOne")
            }
            onPressItem:
            {
                if (menuEnabled)
                    Qt.createComponent("QReceiptItemMenu.qml").createObject(root, {pDocumentItem:model.modelData});
            }
        }
    }
}
