import QtQuick 2.9
import QtQuick.Controls 1.4

import TCustomer 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "customeredit"

    property bool isNew: true
    property real lastVisibleY: 0

    property TCustomer pCustomer
    property TCustomer tCustomer

    Component.onCompleted:
    {
        tCustomer = customerCommon.getNewCustomer();
        if(isNew) txtID.text = customerCommon.getNewId();
        txtID.forceActiveFocus();
    }

    function getActiveCustomer()
    {
        if (isNew)
            return tCustomer;
        else
            return pCustomer;
    }

    function isChanged()
    {
        if (getActiveCustomer().id != txtID.text) return true;
        if (getActiveCustomer().idc != txtCID.text) return true;
        if (getActiveCustomer().line1 != txtTitle.text) return true;
        if (getActiveCustomer().line2 != txtAddress.text) return true;
        if (getActiveCustomer().line3 != txtCity.text) return true;
        if (getActiveCustomer().line4 != txtPostalNo.text) return true;
        return false;
    }

    function settCustomer()
    {
        tCustomer.id = txtID.text;
        tCustomer.idc = txtCID.text;
        tCustomer.line1 = txtTitle.text;
        tCustomer.line2= txtAddress.text;
        tCustomer.line3 = txtCity.text;
        tCustomer.line4 = txtPostalNo.text;
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
            settCustomer();

            var ret = false;
            if(isNew)
                ret = customerCommon.insertCustomer(tCustomer);
            else
                ret = customerCommon.updateCustomer(pCustomer, tCustomer);

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
        var ret = customerCommon.deleteCustomer(getActiveCustomer());
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

    function isValid()
    {
        return (txtID.text != "" && txtID.text != "0"
                && txtCID.text != "" && txtTitle.text != "");
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

        Column {
            id: main
            width: parent.width
            spacing: 20

                MyTextFieldH {
                    id: txtID
                    label: qsTr("Šifra")
                    text: getActiveCustomer().id
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width:  parent.width - 40
                    isValid: (text != "" && text != "0")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                    onDonePressed: txtCID.setFocus()
                }
                MyTextFieldH {
                    id: txtCID
                    label: qsTr("Identifikacioni broj")
                    text: getActiveCustomer().idc
                    validator: IntValidator {bottom: 0;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    maximumLength : 13
                    width:  parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtCID);
                    onDonePressed: txtTitle.setFocus()
                }
                MyTextFieldH {
                    id: txtTitle
                    label: qsTr("Naziv")
                    text: getActiveCustomer().line1
                    maximumLength : mSettings.paperWidth
                    width:  parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtTitle);
                    onDonePressed: txtAddress.setFocus()
                }
                MyTextFieldH {
                    id: txtAddress
                    label: qsTr("Adresa")
                    text: getActiveCustomer().line2
                    maximumLength : mSettings.paperWidth
                    width:  parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtAddress);
                    onDonePressed: txtCity.setFocus()
                }
                MyTextFieldH {
                    id: txtCity
                    label: qsTr("Grad")
                    text: getActiveCustomer().line3
                    maximumLength : mSettings.paperWidth
                    width:  parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtCity);
                    onDonePressed: txtPostalNo.setFocus()
                }
                MyTextFieldH {
                    id: txtPostalNo
                    label: qsTr("Poštanski broj")
                    text: getActiveCustomer().line4
                    maximumLength : mSettings.paperWidth
                    width:  parent.width - 40
                    onDonePressed: Qt.inputMethod.hide()
                }
            }
        }
    }
}

