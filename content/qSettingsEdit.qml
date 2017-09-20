import QtQuick 2.9
import QtQuick.Controls 1.4

import TSettings 1.0

import "../style"
import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "settingsedit"

    property TSettings tSettings

    Component.onCompleted:
    {
        tSettings = settingsCommon.getTempSettings();
    }

    function isChanged()
    {
        if (mSettings.paperWidth != JsCommon.getComboboxSelectedItemValue(cmbPaperWidth)) return true;
        if (mSettings.unit != txtUnit.text) return true;
        if (mSettings.portNo != txtPort.text) return true;
        if (mSettings.noteCashier != cbNoteCashier.checked) return true;
        if (mSettings.notePredefined != txtNotePredefined.text) return true;
        return false;
    }

    function settSettings()
    {
        tSettings.paperWidth = JsCommon.getComboboxSelectedItemValue(cmbPaperWidth);
        tSettings.unit = txtUnit.text;
        tSettings.portNo = txtPort.text;
        tSettings.noteCashier = cbNoteCashier.checked;
        tSettings.notePredefined = txtNotePredefined.text;
    }

    function _save()
    {
        if (isChanged())
        {
            settSettings();
            settingsCommon.setSettings(tSettings);
        }
        stackView.pop({immediate: true});
    }

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function _info()
    {
        Qt.createComponent("../content/QInfo.qml").createObject(root);
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
                    id: txtUnit
                    label: qsTr("Broj poslovne jedinice")
                    text: mSettings.unit
                    validator: IntValidator {bottom: 0;}
                    inputMethodHints: Qt.ImhPreferNumbers
                    width: parent.width - 40
                    isValid: (text != "" && text != "0")
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtUnit);
                    onDonePressed: txtPort.setFocus()
                }
                MyTextFieldH {
                    id: txtPort
                    label: qsTr("Port")
                    text: mSettings.portNo
                    width: parent.width - 40
                    placeholderText: qsTr("npr. win: COM5, android: ttyS5")
                    visible: true
                    onFocusGet: JsCommon.flickAreaHorizontally(flickArea, txtPort);
                    onDonePressed: txtNotePredefined.setFocus()
                }
                MyTextAreaH {
                    id: txtNotePredefined
                    label: qsTr("Predefinisana napomena")
                    width: parent.width - 40
                    text: mSettings.notePredefined
                    onFocusChanged: JsCommon.flickAreaHorizontally(flickArea, txtNotePredefined);
                    onDonePressed: Qt.inputMethod.hide()
                }
                MyCheckBoxH
                {
                    id: cbNoteCashier
                    label: qsTr("Prikaz kasira u napomeni")
                    width: parent.width - 40
                    borderColor: "white"
                    checked: mSettings.noteCashier
                }
                MyComboBoxH {
                    id: cmbPaperWidth
                    label: qsTr("Širina papira")
                    height: 50
                    width: parent.width - 40
                    model: settingsCommon.getPaperWidths()
                    textRole: "name"
                    currentIndex: settingsCommon.getPaperWidthIndex(mSettings.paperWidth)
                    //style: mStyle.comboBoxValid
                    visible: false
                    //onFocusGet: JsCommon.flickAreaHorizontally(flickArea, cmbPaperWidth);
                }
            }
        }
    }
}

