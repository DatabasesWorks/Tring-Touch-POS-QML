import QtQuick 2.9
import QtQuick.Controls 1.4

import TGroup 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "groupedit"

    property bool isNew: true

    property TGroup pGroup
    property TGroup tGroup

    Component.onCompleted:
    {
        tGroup = groupCommon.getNewGroup();
        if(isNew) txtID.text = groupCommon.getNewId();
        txtID.forceActiveFocus();
    }

    function getActiveGroup()
    {
        if (isNew)
            return tGroup;
        else
            return pGroup;
    }


    function isChanged()
    {
        if (getActiveGroup().id != txtID.text) return true;
        if (getActiveGroup().name != txtGroup.text) return true;
        return false;
    }

    function settGroup()
    {
        tGroup.id = txtID.text;
        tGroup.name = txtGroup.text;
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
            settGroup();

            var ret = false;
            if(isNew)
                ret = groupCommon.insertGroup(tGroup);
            else
                ret = groupCommon.updateGroup(pGroup, tGroup);
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
        var ret = groupCommon.deleteGroup(getActiveGroup());
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
                && txtGroup.text != "");
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
        clip: true

        Column {
            id: main
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtID
                    label: qsTr("Šifra")
                    text: getActiveGroup().id
                    width: parent.width - 40
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers;
                    isValid: (text != "" && text != "0")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                    onDonePressed: txtGroup.setFocus()
                }
                MyTextFieldH {
                    id: txtGroup
                    label: qsTr("Naziv")
                    text: getActiveGroup().name
                    width: parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtGroup);
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }
}

