import QtQuick 2.9

import "./controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name: "menu"

    property var model: [
        { title: qsTr("Prodaja"), page: "content/QSale.qml" },
        { title: qsTr("Snimljeni računi"), page: "content/QReceipt.qml" },
        { title: qsTr("Fiskalni izvještaji"), page: "content/QFiscalReports.qml" },
        { title: qsTr("Nefiskalni izvještaji"), page: "content/QNonfiscalReports.qml" },
        { title: qsTr("Uplata/isplata novca"), page: "content/QPayInOut.qml" },
        { title: qsTr("Nefiskalni tekst"), page: "content/QNonfiscalText.qml" },
        { title: qsTr("Duplikati"), page: "content/QDuplicate.qml" },
        { title: qsTr("Dokumenti"), page: "content/QDocuments.qml" },
        { title: qsTr("Administracija"), page: "content/QAdmin.qml" }
        //{ title: qsTr("Backup"), page: "content/QBackup.qml" }
    ]

    function _logout()
    {
        stackView.clear();
        stackView.push({item:Qt.resolvedUrl("QLogin.qml"), immediate:true})
    }

    ListView {
        id: mainList
        anchors.fill: parent
        interactive: contentHeight > height
        model: root.model
        clip: true

        delegate: AndroidDelegate {
            property var item: model.modelData ? model.modelData : model
            text:   item.title
            onClicked: stackView.push({item:Qt.resolvedUrl(item.page), immediate:true})
        }
    }
}
