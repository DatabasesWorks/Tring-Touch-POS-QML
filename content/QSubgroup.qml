import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "subgroup"

    function _search()
    {
        txtSearch.visible = !txtSearch.visible
    }
    function _refreshMe()
    {
        listSubgroup.model = subgroupCommon.getSubgroups(txtSearch.inputText)
    }
    function _new()
    {
        stackView.push({item: Qt.resolvedUrl("QSubgroupEdit.qml"), immediate: true})
    }
    function _close()
    {
        stackView.pop({immediate: true});
    }

    Search {
        id: txtSearch
        visible: false
        onTextInput: listSubgroup.model = subgroupCommon.getSubgroups(txtSearch.inputText)
        onTimerEnded:
        {
            if (txtSearch.inputText == "")
                txtSearch.visible = false
        }
    }

    ListView {
        id:listSubgroup
        clip: true
        width: parent.width
        height: parent.height
        interactive: contentHeight > height
        y: txtSearch.visible ? txtSearch.height : 0

        model: subgroupCommon.getSubgroups("")

        delegate: AndroidDelegate {
            id:txtTest
            text:   model.modelData.name
            onClicked:
            {
                stackView.push({item: Qt.resolvedUrl("QSubgroupEdit.qml"),
                               properties: {pSubgroup:model.modelData, isNew:false}, immediate: true})
            }
         }

         Behavior on y {
             NumberAnimation{ duration: 200 }
         }
    }

}
