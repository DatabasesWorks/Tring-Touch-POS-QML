import QtQuick 2.9

import "../controls"

Item {
    id: root

    property string _name : "document"

    function _close()
    {
        stackView.pop({immediate: true});
    }

    property var modelDocument: [
        { title: qsTr("Ulazne kalkulacije"), page: "QInput.qml" },
        { title: qsTr("Kartica artikala"), page: "QItemCard.qml" },
        { title: qsTr("Lager lista"), page: "QStock.qml" }
    ]

    ListView {
        model: root.modelDocument
        clip: true
        width: parent.width
        height: parent.height
        interactive: contentHeight > height

        delegate: AndroidDelegate {
            text:   model.modelData.title
            onClicked: {
                stackView.push({item: Qt.resolvedUrl(model.modelData.page),immediate: true});
            }
        }
    }
}


