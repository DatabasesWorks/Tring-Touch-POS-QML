import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

import TDocument 1.0
import TDocumentItem 1.0
import TReceiptItemCommon 1.0
import TCustomer 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    property string _name : "sale"

    property bool isNew: true
    property bool isLandscape: true

    property bool isAll: true
    property bool isTop: false
    property bool isGroup: false

    property int selectedSubgroup : 0
    property int selectedGroup : 0
    property string searchTitle : ""

    property TDocument pDocument
    property TCustomer pCustomer

    Component.onCompleted:
    {
        loadItems();
        loadAll();
    }

    function setComponent()
    {
        _name = isNew ? "sale" : "receiptedit";
        toolbar.setToolbar(_name);
        setControls();
    }

    function loadAll()
    {
        setComponent();
        loadReceipt();
        loadReceiptItems();
        _setReceiptInfo();
    }

    function _setReceiptInfo()
    {
        setTitle();
        setSubtitle();
    }

    function setControls()
    {
        recToolbar.enabled = isNew;
        itemList.enabled = isNew;
        rectItemGroupSubgroup.enabled = isNew;
    }

    function _newReceipt()
    {
        isNew = true;
        loadAll();
    }

    function loadReceipt()
    {
        if(isNew)
        {
            pDocument = receiptCommon.getNewReceipt();
        }
    }

    function _save()
    {
        if (receiptItemList.model.length > 0)
        {
            Qt.createComponent("../content/QReceiptSave.qml").createObject(root,{pDocument:pDocument});
        }
    }

    function _setNumber()
    {
        Qt.createComponent("../content/QReceiptNumber.qml").createObject(root,{pDocument:pDocument});
    }

    function _delete()
    {
        JsCommon.showDialog(root, qsTr("Da li želite obrisati izabranu stavku?"), "delete");
    }

    function _dSave()
    {
        _save();
    }

    function _dNew()
    {
        _newReceipt();
    }

    function _dDelete()
    {       
        var result = receiptCommon.receiptDelete(pDocument, receiptCommon)

        if (0 == result)
        {
             _newReceipt();
        }
        else
        {
            JsCommon.checkErrorCode(result);
        }
    }

    function _print()
    {
        pDocument.cash = 0;
        pDocument.check = -1;
        pDocument.card = -1;
        pDocument.transferOrder = -1;

        var result = receiptCommon.receiptPrint(pDocument, receiptItemCommon.getReceiptItemList(),
                                                 receiptCommon, isNew, false);

        if (0 == result)
        {
            stackView.__currentItem._newReceipt();
        }
        else
        {
            JsCommon.checkErrorCode(result);
        }
    }

    function loadReceiptItems()
    {
        receiptItemCommon.fillReceiptItemList(pDocument.id);
        receiptItemList.model = receiptItemCommon.getReceiptItemList();
    }

    TReceiptItemCommon
    {
        id: receiptItemCommon
        onTotalCalculated: calculateTotal();
    }

    function setActiveSmallButton(_isAll, _isTop, _isGroup)
    {
        if (_isAll)
        {
            isAll = true;
            isTop = isGroup = false;
        }
        else if (_isTop)
        {
            isTop = true;
            isAll = isGroup = false;
        }
        else if (_isGroup)
        {
            isGroup = true;
            isAll = isTop = false;
        }
    }

    function loadActiveitemList(_isAll, _isTop, _isGroup)
    {
        setActiveSmallButton(_isAll, _isTop, _isGroup);
        loadItems();
    }

    function loadItems()
    {
        if (isAll)
            itemList.model = itemCommon.getItems(searchTitle);
        else if (isTop)
            itemList.model = itemCommon.getTopItems(searchTitle);
        else if (isGroup)
            itemList.model = itemCommon.getItemsByGroupSubgroup(searchTitle, selectedGroup, selectedSubgroup);

        itemList.currentIndex = -1;
    }

    function calculateTotal()
    {
        rectTotalBottom.total = receiptItemCommon.getTotal();
    }

    function setSubtitle()
    {
        if (typeof pDocument == "undefined" || pDocument == null)
            return;

        var subtitle = "";
        if (pDocument.customerId > 0)
        {
            var line1 = customerCommon.customerGetLine1(pDocument.customerId);
            subtitle = qsTr("Kupac: ") + line1;
        }
        toolbar.setCustomSubtitle(subtitle);
    }

    function setTitle()
    {
        var title = (pDocument.title != "") ? pDocument.title : qsTr("Račun");
        toolbar.setCustomTitle(title);
    }

    function _new()
    {
        if(isNew && receiptItemList.model.length > 0)
        {
            JsCommon.showDialog(root, qsTr("Da li želite sačuvati račun?"), "saveOrNew");
        }
        else
        {
            _newReceipt();
        }
    }

    function search(searchText)
    {
        searchTitle = searchText;
        loadActiveitemList(isAll, isTop, isGroup);
    }

    function _close()
    {
        stackView.pop({immediate: true});

         if (stackView.__currentItem._name == "receipt")
             stackView.__currentItem._refreshMe();
    }

    function _refreshReceiptItems()
    {
        receiptItemList.model = receiptItemCommon.getReceiptItemList();
    }

    function resizeGridView(listWidth)
    {
        if (listWidth > 600)
        {
            itemList.cellWidth = listWidth/5
            itemList.cellHeight = listWidth/5 - 10
        }
        else if (listWidth > 540)
        {
            itemList.cellWidth = listWidth/4
            itemList.cellHeight = listWidth/4 - 10
        }
        else if (listWidth > 450)
        {
            itemList.cellWidth = listWidth/3
            itemList.cellHeight = listWidth/3 - 10
        }
        else
        {
            itemList.cellWidth = listWidth/2
            itemList.cellHeight = listWidth/2 - 10
        }
    }

    /* background */
    Rectangle {
        id: rectBackground
        anchors.margins: 10
        anchors.fill: parent
        color: mStyle.colorAppBackground

        /* toolbar */
        Rectangle {
            id: recToolbar
            anchors.top: parent.top
            anchors.right: isLandscape ? rectReceiptItemList.left : parent.right
            anchors.rightMargin: isLandscape ? 5 : 0
            anchors.left: parent.left
            height: 50
            color: "transparent"

            RowLayout
            {
                anchors.fill: parent
                /* show all items button */
                SmallButton {
                    id: rectAll
                    borderColor: mStyle.colorBorderExpressed
                    source: "../images/all.png"
                    opacity: isNew ? 1.0 : 0.5

                    onClicked: {
                        forceActiveFocus();
                        itemList.visible = true;
                        loadActiveitemList(true, false, false);
                     }
                }
                /* show favorite items button */
                SmallButton {
                    id: rectTop
                    borderColor: mStyle.colorBorderExpressed
                    source: "../images/topY.png"
                    opacity: isNew ? 1.0 : 0.5

                    onClicked: {
                        forceActiveFocus();
                        itemList.visible = true;
                        loadActiveitemList(false, true, false);
                    }
                 }
                /* show groups and subgroups button */
                SmallButton {
                    id: rectGroups
                    borderColor: mStyle.colorBorderExpressed
                    source: "../images/list.png"
                    opacity: isNew ? 1.0 : 0.5

                    onClicked: {
                        forceActiveFocus();
                        itemList.visible = false;
                    }
                }
                /* show ordered items button */
                SmallButton {
                    id: rectReceipt
                    borderColor: mStyle.colorBorderExpressed
                    source: "../images/to_do.png"
                    visible: isLandscape ? false : true

                    onClicked: {
                        forceActiveFocus();
                        if (rectReceiptItemList.opacity == 0.0)
                            rectReceiptItemList.opacity = 1.0;
                        else
                            rectReceiptItemList.opacity = 0.0;
                    }
                }
                /* search items */
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    opacity: isNew ? 1.0 : 0.5

                    Search {
                       anchors.fill: parent
                       startTimerOnFocus: true
                       timerInterval: 100
                       onTimerEnded: search(inputText)
                       onTextClear: inputText = ""
                    }
                }

            }
        }
        /* item list or groups/subgroups list */
        Rectangle {
            id: rectItemGroupSubgroup
            anchors.top: recToolbar.bottom
            anchors.right: (rectReceiptItemList.opacity == 1.0) ? rectReceiptItemList.left : parent.right
            anchors.rightMargin: (rectReceiptItemList.opacity == 1.0) ? 5 : 0
            anchors.bottom: isLandscape ? parent.bottom : recTotal.top
            anchors.bottomMargin: isLandscape ? 0 : 5
            anchors.left: parent.left
            anchors.topMargin: 5
            color: "transparent"
            border.color: mStyle.colorBorderExpressed
            border.width: 1
            opacity: isNew ? 1.0 : 0.5

            QGroupSubgroupList {
                id: listGroupSubgroup
                anchors.fill: parent
                visible: !itemList.visible
                onItemClicked: {
                    forceActiveFocus();
                    itemList.visible = true;
                    selectedGroup = group
                    selectedSubgroup = subgroup;
                    loadActiveitemList(false, false, true);
                }
            }

            QItemList {
                id: itemList
                anchors {fill: parent; leftMargin: 5; topMargin: 5; bottomMargin: 5; rightMargin: -5}
                visible: true
                receiptId: pDocument != null ? pDocument.id : 0
                onItemSelected:
                {
                    forceActiveFocus();
                    receiptItemList.model = receiptItemCommon.getReceiptItemList();
                }
                onWidthChanged:
                    root.resizeGridView(itemList.width)
                }
        }
        /* receipt items */
        Rectangle {
            id: rectReceiptItemList
            anchors.top: isLandscape ? parent.top : recToolbar.bottom
            anchors.topMargin: isLandscape ? 0 : 5
            anchors.right: parent.right
            anchors.bottom: recTotal.top
            anchors.bottomMargin: 5
            width: (opacity == 1.0) ? (isLandscape ? 300 : 240) : 0
            color: "#3e3e3e"
            border.color: mStyle.colorBorderExpressed
            border.width: 1
            Behavior on opacity {
                NumberAnimation { property: "opacity"; duration: 100; easing.type: Easing.InOutSine}
            }

            QReceiptItem {
                id: receiptItemList
                //model: receiptItemCommon.getReceiptItemList()
                anchors.fill: parent
                menuEnabled: isNew
                onSelectedItem: {
                    forceActiveFocus();

                    if (option == "Add")
                        receiptItemCommon.addReceiptItem(pDocumentItem);
                    else if (option == "DeleteOne")
                        receiptItemCommon.deleteReceiptItem(pDocumentItem, true);
                    else if (option == "DeleteAll")
                        receiptItemCommon.deleteReceiptItem(pDocumentItem, false);
                    else if (option == "Edit") {
                        stackView.push({item: Qt.resolvedUrl("QReceiptItemEdit.qml"),
                                           properties: {pDocumentItem:pDocumentItem,
                                                        isNew:false,
                                                        pReceiptItemCommon:receiptItemCommon},
                                           immediate: true});
                        return;
                    }
                    _refreshReceiptItems();
                }
            }
        }
        Rectangle  {
            id: recTotal
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: isLandscape ? rectItemGroupSubgroup.right : parent.left
            anchors.leftMargin: isLandscape ? 5 : 0
            height: 120
            color: "transparent"

            QTotal {
                id: rectTotalBottom
                //anchors.fill: parent
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
            }

            QMiniMenu {
                id: rectMiniMenu
                anchors.top: rectTotalBottom.bottom
                anchors.right: parent.right
                anchors.left: parent.left

                onSelectedPayment: {
                    forceActiveFocus();
                    if (receiptItemList.model.length > 0)
                    {
                        Qt.createComponent("../content/QPayment.qml").createObject(root,
                                                                                  {total:rectTotalBottom.total,
                                                                                   pDocument:pDocument,
                                                                                   pReceiptItemCommon:receiptItemCommon,
                                                                                   isNew:isNew});
                    }
                }
                onSelectedCustomer: {
                    forceActiveFocus();
                    Qt.createComponent("../content/QReceiptCustomer.qml").createObject(root, {pDocument: pDocument});
                }
                onSelectedReclaim: {
                    forceActiveFocus();
                    Qt.createComponent("../content/QReclaim.qml").createObject(root,
                                                                               {total: rectTotalBottom.total,
                                                                               pDocument: pDocument,
                                                                               pReceiptItemCommon:receiptItemCommon,
                                                                               isNew:isNew});
                }
            }
        }
    }

    Screen.onOrientationChanged: {
        if (Screen.orientation == Qt.PortraitOrientation
                || Screen.orientation == Qt.InvertedPortraitOrientation)
        {
            isLandscape = false;
            rectReceiptItemList.opacity = 0.0;
        }
        else
        {
            isLandscape = true;
            rectReceiptItemList.opacity = 1.0;
        }
    }
}
