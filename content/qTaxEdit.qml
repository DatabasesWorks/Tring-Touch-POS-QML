import QtQuick 2.9
import QtQuick.Controls 1.4

import TTax 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "taxedit"

    property bool isNew: true

    property TTax pTax
    property TTax tTax

    Component.onCompleted:
    {
        tTax = taxCommon.getNewTax();
    }

    function getActiveTax()
    {
        if (isNew)
            return tTax;
        else
            return pTax;
    }

    function isChanged()
    {
        if (getActiveTax().id != txtID.text) return true;
        if (getActiveTax().name != txtName.text) return true;
        if (getActiveTax().taxRate != JsCommon.setDecimalPoint(txtRate.text)) return true;
        if (getActiveTax().code != txtSymbol.text) return true;
        return false;
    }

    function settTax()
    {
        tTax.id = txtID.text;
        tTax.name = txtName.text;
        tTax.taxRate = JsCommon.setDecimalPoint(txtRate.text);
        tTax.code = txtSymbol.text;
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
            settTax();

            var ret = false;
            if(isNew)
                ret = taxCommon.insertTax(tTax);
            else
                ret = taxCommon.updateTax(pTax, tTax);

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
        return ret;
    }

    function _delete()
    {
        if (!isNew)
            JsCommon.showDialog(root, qsTr("Da li želite obrisati izabranu stavku?"), "delete");
    }
    function _dDelete()
    {
        var ret = taxCommon.deleteTax(getActiveTax());
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
        return (txtID.text != "0" && txtID.text != ""
                && txtName.text != "" && txtRate.text != "" );
                //&& txtSymbol.text != "");
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
                    text: getActiveTax().id
                    width: parent.width - 40
                    validator: IntValidator {bottom: 1;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    visible:false;
                    isValid: (text != "" && text != "0")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtID);
                }
                MyTextFieldH {
                    id: txtName
                    label: qsTr("Naziv")
                    text: getActiveTax().name
                    width: parent.width - 40
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtName);
                    onDonePressed: txtRate.setFocus()
                }
                MyTextFieldH {
                    id: txtRate
                    label: qsTr("Stopa")
                    text: JsCommon.setDecimalPlaces(getActiveTax().taxRate, 2)
                    validator: DoubleValidator{bottom: -1; decimals: 2; notation: DoubleValidator.StandardNotation}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    isValid: (text != "")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtRate);
                    onDonePressed: Qt.inputMethod.hide()
                }
                MyTextFieldH {
                    id: txtSymbol
                    label: qsTr("Oznaka")
                    maximumLength: 1
                    text: getActiveTax().code
                    width: parent.width - 40
                    visible: false
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtSymbol);
                }
            }
        }

    }
}

