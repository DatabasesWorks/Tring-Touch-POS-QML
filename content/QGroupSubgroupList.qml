import QtQuick 2.9

import "../controls"

// Accordion list
Item {
    id: root

    // Default width
    width: 360
    // Default height
    height: 640
    // Subitem expansion duration
    property int animationDuration: 100
    // Subitem indentation
    property int indent: 20
    // Scrollbar width
    property int scrollBarWidth: 8
    // Arrow indicator for item expansion
    property string arrow: '../images/arrow.png'
    // Font properties for top level items
    property int headerItemFontSize: 20
    property color headerItemFontColor: "white"
    // Font properties for  subitems
    property int subItemFontSize: headerItemFontSize-1
    property color subItemFontColor: "white"

    signal itemClicked(int group, int subgroup)
    signal itemPressAndHold(int group)

    ListView {
        height: parent.height
        clip: true
        anchors {
            left: parent.left
            right: parent.right
        }
        model: groupCommon.getGroups("")
        delegate: AccordionListDelegate {
            id: txtTest
            text:   model.modelData.name
            group: model.modelData.id
            onItemClicked: {
                root.itemClicked(model.modelData.id, subgroup)
            }
            onItemPressAndHold: {
                root.itemPressAndHold(model.modelData.id)
            }
        }

        focus: true
        spacing: 0
    }
}
