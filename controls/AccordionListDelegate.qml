import QtQuick 2.9

Item {
    id: delegate
    // Modify appearance from these properties
    property int itemHeight: 64
    property alias expandedItemCount: subItemRepeater.count

    // Flag to indicate if this delegate is expanded
    property bool expanded: false

    property alias text: headerItemRect.text
    property int group

    x: 0; y: 0;
    width: root.width
    height: headerItemRect.height + subItemsRect.height

    property int itemX: 10
    property int itemY: 10

    signal itemClicked(int subgroup)
    signal itemPressAndHold()

    // Top level list item.
    AccordionListItem {
        id: headerItemRect
        x: 0; y: 0
        width: parent.width
        height: parent.itemHeight
        onClicked: expanded = !expanded

        fontSize: root.headerItemFontSize
        fontColor: root.headerItemFontColor

        // Arrow image indicating the state of expansion.
        Image {
            id: arrow
            fillMode: "PreserveAspectFit"
            height: parent.height*0.3
            source: root.arrow
            rotation: expanded ? 90 : 0
            smooth: true
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 10
            }
        }
        onPressAndHold: {
            delegate.itemPressAndHold();
        }
    }

    // Subitems are in a column whose height depends
    // on the expanded status. When not expandend, it is zero.
            Item {
                id: subItemsRect
                property int itemHeight: delegate.itemHeight
                property int group: delegate.group

                y: headerItemRect.height
                width: parent.width
                height: expanded ? expandedItemCount * itemHeight : 0
                clip: true

                opacity: 1
                Behavior on height {
                    // Animate subitem expansion. After the final height is reached,
                    // ensure that it is visible to the user.
                    SequentialAnimation {
                        NumberAnimation { duration: root.animationDuration; easing.type: Easing.InOutQuad }
                        //ScriptAction { script: ListView.view.positionViewAtIndex(index, ListView.Contain) }
                    }
                }

                Column
                 {
                     width: parent.width

                    // Repeater creates each sub-ListItem using attributes
                    // from the model.
                    Repeater {
                        id: subItemRepeater
                        model: subgroupCommon.getSubgroupsByGroup(group)//attributes
                        width: subItemsRect.width

                        AccordionListItem {
                            id: subListItem
                            width: delegate.width
                            height: subItemsRect.itemHeight
                            text: model.modelData.name
                            fontSize: root.subItemFontSize
                            fontColor: root.subItemFontColor
                            textIndent: root.indent
                            itemIndex: index
                            onClicked: {
                                delegate.itemClicked(model.modelData.id);
                            }
                        }
                    }
                 }
            }
}
