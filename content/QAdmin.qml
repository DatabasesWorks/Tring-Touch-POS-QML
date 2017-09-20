import QtQuick 2.9

import "../controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "admin"

    function _close()
    {
        stackView.pop({immediate: true});
    }

    property var modelAdmin: [
        { title: qsTr("Artikli"), page: "QItem.qml" },
        { title: qsTr("Komitenti"), page: "QCustomer.qml" },
        { title: qsTr("Grupe"), page: "QGroup.qml" },
        { title: qsTr("Podgrupe"), page: "QSubgroup.qml" },
        { title: qsTr("Porezi"), page: "QTax.qml" },
        { title: qsTr("Kasiri"), page: "QCashier.qml" },
        { title: qsTr("Postavke"), page: "QSettingsEdit.qml" }
    ]

    ListView {
        model: root.modelAdmin
        clip: true
        width: parent.width
        height: parent.height
        interactive: contentHeight > height

        delegate: AndroidDelegate {
            text:   model.modelData.title
            onClicked: {
                if (mCashier.id != 1 && model.modelData.page == "QCashier.qml")
                    return;

                stackView.push({item: Qt.resolvedUrl(model.modelData.page),immediate: true});
            }
        }
    }
}


