import QtQuick 2.9
import QtQuick.Controls 1.4

import TCashier 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "cashieredit"

    property bool isNew: true
    property bool isAdminItem: false

    property TCashier pCashier
    property TCashier tCashier

    Component.onCompleted:
    {
        tCashier = cashierCommon.getNewCashier();
        if(isNew) txtID.text = cashierCommon.getNewId();
        txtID.forceActiveFocus();

        setAdmin();
    }

    function flickAreaMoveHorizontally(flickArea, objectToShow)
    {
        if (focused)
        {
            flickArea.contentX = 0;
            flickArea.contentY = labelObject.y;
        }
    }

    function setAdmin()
    {
        isAdminItem = (!isNew && cashierCommon.isAdmin(pCashier));
    }

    function getActiveCashier()
    {
        if (isNew)
            return tCashier;
        else
            return pCashier;
    }

    function isChanged()
    {
        if (getActiveCashier().id != txtID.text) return true;
        if (getActiveCashier().name != txtName.text) return true;
        if (getActiveCashier().password != txtPassword.text) return true;
        return false;
    }

    function settCashier()
    {
        tCashier.id = txtID.text;
        tCashier.name = txtName.text;
        tCashier.password = txtPassword.text;
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
            settCashier();

            var ret = false;
            if(isNew)
                ret = cashierCommon.insertCashier(tCashier);
            else
                ret = cashierCommon.updateCashier(pCashier, tCashier);

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

    }

    function _delete()
    {
        if (!isNew)
        {
            if (isAdminItem)
            {
                toast.show(qsTr("Zabranjeno brisanje stavke!"));
                return;
            }

            JsCommon.showDialog(root, qsTr("Da li želite obrisati izabranu stavku?"), "delete");
        }
    }

    function _dDelete()
    {
        var ret = cashierCommon.deleteCashier(getActiveCashier());
        if (ret)
        {
            stackView.pop({immediate: true});
            stackView.__currentItem._refreshMe();
        }
        else
        {
            toast.show(qsTr("Greška baze podataka!"));
        }
    }

    function _close()
    {
        if (isChanged())
            showDialog();
        else
            stackView.pop({immediate: true});
    }

    function isInputValid()
    {
        return (txtID.text != "" && txtID.text != "0"
                && txtName.text != "" && txtPassword.text != "");
    }

    function isPasswordAvailable()
    {
         return cashierCommon.isPasswordAvailable(txtPassword.text, txtID.text);
    }

    function isValid()
    {
        if (isInputValid())
        {
            if (isPasswordAvailable())
            {
                return true;
            }

            toast.show(qsTr("Šifra već postoji!"));
        }
        else
        {
            toast.show(qsTr("Podaci nisu validni!"));

        }

        return false;
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
            contentWidth: main.width; contentHeight: main.height * 1.1
            flickableDirection: Flickable.VerticalFlick

        Column {
            id: main
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtID
                    label: qsTr("ID")
                    text: getActiveCashier().id
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers;
                    width:  parent.width - 40
                    isValid: (text != "" && text != "0")
                    enabled: !isAdminItem
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                    onDonePressed: txtName.setFocus()
                }
                MyTextFieldH {
                    id: txtName
                    label: qsTr("Kasir")
                    text: getActiveCashier().name
                    maximumLength : 13
                    width: parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtName);
                    onDonePressed: txtPassword.setFocus()
                }
                MyTextFieldH {
                    id: txtPassword
                    label: qsTr("Lozinka")
                    text: getActiveCashier().password
                    maximumLength : 6
                    echoMode: TextInput.Password
                    width:  parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtPassword);
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }
}

