import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "receipt"

    function _search()
    {
        txtSearch.visible = !txtSearch.visible
    }
    function _refreshMe()
    {
        listReceipt.model = receiptCommon.searchNonfiscalReceipts(txtSearch.inputText)
    }
    function _close()
    {
        stackView.pop({immediate: true})
    }
    function _new()
    {
        stackView.push({item: Qt.resolvedUrl("QSale.qml"), immediate: true})
    }

    Search {
        id: txtSearch
        visible: false
        onTextInput: listReceipt.model = receiptCommon.searchNonfiscalReceipts(txtSearch.inputText)
        onTimerEnded:
        {
            if (txtSearch.inputText == "")
                txtSearch.visible = false
        }
    }

    ListView {
        id:listReceipt
        clip: true
        width: parent.width
        height: parent.height
        interactive: contentHeight > height
        y: txtSearch.visible ? txtSearch.height : 0
        model: receiptCommon.getNonfiscalReceipts();

        delegate: AndroidDelegate {
             id:txtTest
             text:   model.modelData.title
             onClicked: {
                 stackView.push({item: Qt.resolvedUrl("QSale.qml"),
                                properties: {pDocument:model.modelData, isNew:false}, immediate: true});
             }
        }

        Behavior on y {
            NumberAnimation{ duration: 200 }
        }
    }
}
