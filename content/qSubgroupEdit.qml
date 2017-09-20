import QtQuick 2.9
import QtQuick.Controls 1.4

import TSubgroup 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "subgroupedit"

    property bool isNew: true

    property TSubgroup pSubgroup
    property TSubgroup tSubgroup

    Component.onCompleted:
    {
        tSubgroup = subgroupCommon.getNewSubgroup();
        if(isNew) txtID.text = subgroupCommon.getNewId();
        txtID.forceActiveFocus();
    }

    function getActiveSubgroup()
    {
        if (isNew)
            return tSubgroup;
        else
            return pSubgroup;
    }

    function isChanged()
    {
        if (getActiveSubgroup().id != txtID.text) return true;
        if (getActiveSubgroup().groupId != JsCommon.getComboboxSelectedItemId(cmbGroup)) return true;
        if (getActiveSubgroup().name != txtSubgroup.text) return true;
        return false;
    }

    function settSubgroup()
    {
        tSubgroup.id = txtID.text;
        tSubgroup.groupId = JsCommon.getComboboxSelectedItemId(cmbGroup);
        tSubgroup.name = txtSubgroup.text;
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
            settSubgroup();

            var ret = false;
            if(isNew)
                ret = subgroupCommon.insertSubgroup(tSubgroup);
            else
                ret = subgroupCommon.updateSubgroup(pSubgroup, tSubgroup);

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
        var ret = subgroupCommon.deleteSubgroup(getActiveSubgroup());
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

    function isValid()
    {
        return (txtID.text != "" && txtID.text != "0"
                && txtSubgroup.text != "");
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.centerIn: root
        anchors.topMargin: 20
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        color: mStyle.colorAppBackground

        Flickable {
        id: flickArea
        width: root.width; height: root.height
        interactive: contentHeight > height
        contentWidth: main.width; contentHeight: main.height * 1.5
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: main
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtID
                    label: qsTr("Šifra")
                    text: getActiveSubgroup().id
                    width: parent.width - 40
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    isValid: (text != "" && text != "0")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                    onDonePressed: txtSubgroup.setFocus()
                }
                MyTextFieldH {
                    id: txtSubgroup
                    label: qsTr("Podgrupa")
                    text: getActiveSubgroup().name
                    width: parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtSubgroup);
                    onDonePressed: cmbGroup.setFocus()
                }
                MyComboBoxH {
                    id: cmbGroup
                    label: qsTr("Grupa")
                    model: groupCommon.getGroups("")
                    textRole: "name"
                    currentIndex: groupCommon.getGroupIndex(getActiveSubgroup().groupId)
                    width: parent.width - 40
                    isValid: (currentText != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, cmbGroup);
                }
            }
        }
    }
}
