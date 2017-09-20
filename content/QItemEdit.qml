import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import TItem 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon
import "../style"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "itemedit"

    property bool isNew: true

    property TItem pItem
    property TItem tItem

    Component.onCompleted:
    {
        tItem = itemCommon.getNewItem();
        if(isNew) txtID.text = itemCommon.getNewId();
        txtID.forceActiveFocus();
    }

    function getActiveItem()
    {
        if (isNew)
            return tItem;
        else
            return pItem;
    }

    function isChanged()
    {
        if (getActiveItem().id != txtID.text) return true;
        if (getActiveItem().top != cbTop.checked) return true;
        if (getActiveItem().name != txtName.text) return true;
        if (getActiveItem().groupId != JsCommon.getComboboxSelectedItemId(cmbGroup)) return true;
        if (getActiveItem().subgroupId != JsCommon.getComboboxSelectedItemId(cmbSubgroup)) return true;
        if (getActiveItem().taxId != JsCommon.getComboboxSelectedItemId(cmbTax)) return true;
        if (getActiveItem().price != JsCommon.setDecimalPoint(txtPrice.text)) return true;
        if (getActiveItem().barcode != txtBarcode.text) return true;
        return false;
    }

    function settItem()
    {
        tItem.id = txtID.text;
        tItem.top = cbTop.checked;
        tItem.name = txtName.text;
        tItem.groupId = JsCommon.getComboboxSelectedItemId(cmbGroup);
        tItem.subgroupId = JsCommon.getComboboxSelectedItemId(cmbSubgroup);
        tItem.taxId = JsCommon.getComboboxSelectedItemId(cmbTax);
        tItem.price = JsCommon.setDecimalPoint(txtPrice.text);
        tItem.barcode = txtBarcode.text;
    }

    function isValid()
    {
        return (txtID.text != "0" && txtID.text != ""
                && txtName.text != "" && txtPrice.text != ""
                && cmbGroup.currentText != "" && cmbSubgroup.currentText != "");
    }

    function showDialog()
    {
        JsCommon.showDialog(root, qsTr("Da li želite snimiti izmjene?"), "saveOrPop");
    }

    function _save()
    {
        if (isChanged())
            _dSave();
        else
            stackView.pop({immediate: true});
    }

    function _dSave()
    {
        if (isValid())
        {
            settItem();

            var ret = false;
            if(isNew)
                ret = itemCommon.insertItem(tItem);
            else
                ret = itemCommon.updateItem(pItem, tItem);

            if(ret)
            {
                stackView.pop({immediate: true});
                stackView.__currentItem._refreshMe();
            }
            else
            {
                toast.show(qsTr("Greška baze podataka!"));
            }
        }
        else
        {
            toast.show(qsTr("Podaci nisu validni!"));
        }
    }

    function _delete()
    {
        if (!isNew)
            JsCommon.showDialog(root, qsTr("Da li želite obrisati izabranu stavku?"), "delete");
    }
    function _dDelete()
    {
        var ret = itemCommon.deleteItem(getActiveItem());
        if (ret)
        {
            stackView.pop({immediate: true});
            stackView.__currentItem._refreshMe();
        }
        else
        {
            toast.show(qsTr("Greška baze podataka!"));
        }
        return ret;
    }

    function _close()
    {
        if (isChanged())
            showDialog();
        else
            stackView.pop({immediate: true});
    }

    function getSubgroupIndex()
    {       
        var id = JsCommon.getComboboxSelectedItemId(cmbGroup);
        cmbSubgroup.model = subgroupCommon.getSubgroupsByGroup(id);

        return subgroupCommon.getSubgroupIndex(getActiveItem().subgroupId, cmbSubgroup.model);
    }

    function getTaxIndex()
    {
        if (isNew)
            return taxCommon.getTaxIndex(2);
        else
            return taxCommon.getTaxIndex(pItem.taxId);
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.margins: 20
        color: mStyle.colorAppBackground

        Flickable {
            id: flickArea
            width: root.width; height: root.height
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: main.width; contentHeight: main.height * 1.5
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: main
                width: parent.width
                spacing: 20

                MyTextFieldH {
                    id: txtID
                    label: qsTr("Šifra")
                    text: getActiveItem().id
                    width: parent.width - 40
                    isValid: (text != "" && text != "0")
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                    onDonePressed: txtName.setFocus()
                }
                MyTextFieldH {
                    id: txtName
                    label: qsTr("Naziv")
                    text: getActiveItem().name
                    width: parent.width - 40
                    isValid: (text != "")
                    maximumLength : mSettings.paperWidth
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtName);
                    onDonePressed: txtBarcode.setFocus()
                }
                MyTextFieldH {
                    id: txtBarcode
                    label: qsTr("Barkod")
                    text: getActiveItem().barcode
                    width: parent.width - 40
                    inputMethodHints: Qt.ImhPreferNumbers
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtBarcode);
                    onDonePressed: txtPrice.setFocus()
                }
                MyTextFieldH {
                    id: txtPrice
                    label: qsTr("Cijena")
                    validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    text: JsCommon.setDecimalPlaces(getActiveItem().price, 2)
                    width: parent.width - 40
                    isValid: (text != "" && JsCommon.setDecimalPoint(text) != JsCommon.setDecimalPoint(0.00))
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtPrice);
                    onDonePressed: cmbTax.setFocus()
                }
                MyComboBoxH {
                    id: cmbTax
                    label: qsTr("Porez")
                    width: parent.width - 40
                    model: taxCommon.getTaxes("")
                    textRole: "name"
                    currentIndex: getTaxIndex()
                    isValid: (currentText != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, cmbTax);
                }
                MyComboBoxH {
                    id: cmbGroup
                    label: qsTr("Grupa")
                    width: parent.width - 40
                    model: groupCommon.getGroups("")
                    textRole: "name"
                    currentIndex: groupCommon.getGroupIndex(getActiveItem().groupId)
                    isValid: (currentText != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, cmbGroup);

                    onIndexChanged: {
                        cmbSubgroup.currentIndex = getSubgroupIndex();
                    }
                }
                MyComboBoxH {
                    id: cmbSubgroup
                    label: qsTr("Podgrupa")
                    width: parent.width - 40
                    textRole: "name"
                    isValid: (currentText != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, cmbSubgroup);
                }
                MyCheckBoxH
                {
                    id: cbTop
                    width: parent.width
                    label: qsTr("Favorit")
                    checked: getActiveItem().top
                    borderColor: "white"
                }
            }
        }
    }
}

