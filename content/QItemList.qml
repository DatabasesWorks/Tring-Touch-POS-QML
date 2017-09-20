import QtQuick 2.9

import TItem 1.0

import "../controls"

Item {
    id: root

    property alias model: view.model
    property alias currentIndex: view.currentIndex

    property int cellWidth: 0//180
    property int cellHeight: 0//160

    property int receiptId: 0
    property double izlaz: 0

    signal itemSelected()

    Component {
        id: highlight
        Rectangle {
            width: view.cellWidth - 10
            height: view.cellHeight - 10
            color: mStyle.colorListHighlight
            radius: 5
            x: (view.currentItem == null) ? 0 : view.currentItem.x
            y: (view.currentItem == null) ? 0 : view.currentItem.y
        }
    }

    GridView {
        id: view
        anchors.fill: parent
        cellHeight: root.cellHeight
        cellWidth: root.cellWidth
        interactive: contentHeight > height
        highlightFollowsCurrentItem: false
        highlight: highlight

        clip: true
        delegate: TextDelegate {
            id: delegate
            contentWidth: view.cellWidth - 10
            contentHeight: view.cellHeight - 10
            textTitle: model.modelData.name
            istop: model.modelData.top
            topSource: model.modelData.top ? "../images/topY.png" : "../images/topW.png"
            onClicked: {
                view.currentIndex = index;
                receiptItemCommon.addItemToReceipt(model.modelData);
                itemSelected();
            }
            onTopClicked: itemCommon.setTopItem(model.modelData);
        }
    }
}
