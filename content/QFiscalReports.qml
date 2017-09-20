import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "fiscalreports"

    property var fromDate
    property var toDate

    property MyTextField dataFiled

    function setDateFieldsOpacity()
    {
        var id = model[cmbReports.currentIndex].id;

        if (txtFromDate != null && txtToDate != null)
                    txtFromDate.isEnabled = txtToDate.isEnabled = (id == 2);
    }

    function _print()
    {
        var res = 0;
        if(0 == model[cmbReports.currentIndex].id)
        {
            res = common.tflXReport();
            JsCommon.checkErrorCode(res);
        }
        else if (1 == model[cmbReports.currentIndex].id)
        {
            res = common.tflZReport();
            JsCommon.checkErrorCode(res);
        }
        else if (2 == model[cmbReports.currentIndex].id)
        {
            getPeriod();
            res = common.tflPeriodicalReport(fromDate, toDate);
            JsCommon.checkErrorCode(res);
        }
    }

    property var model: [
        { title: qsTr("Presjek stanja"), id: 0 },
        { title: qsTr("Dnevni izvještaj"), id: 1 },
        { title: qsTr("Periodični izvještaj"), id: 2 }
    ]

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function _setDate(selectedDate)
    {
        dataFiled.text = Qt.formatDate(selectedDate, "dd/MM/yyyy")
    }

    function getPeriod()
    {
        fromDate = getDateFromText(txtFromDate.text, true);
        toDate = getDateFromText(txtToDate.text, false);
    }

    function getDateFromText(text, isFrom)
    {
        var newDate = new Date();
        newDate.setDate(text.substr(0, 2));
        newDate.setMonth(text.substr(3, 2) - 1);
        newDate.setFullYear(text.substr(6, 4));
        if(isFrom)
        {
            newDate.setHours(0);
            newDate.setMinutes(0);
            newDate.setSeconds(0);
        }
        else
        {
            newDate.setHours(23);
            newDate.setMinutes(59);
            newDate.setSeconds(59);
        }

        return newDate;
    }

    function opetDatePicker(field)
    {
        dataFiled = field;
        var newDate = getDateFromText(field.text);
        Qt.createComponent("../controls/MyCalendar.qml").createObject(root, {selectedDate:newDate});
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

                MyComboBoxH {
                    id: cmbReports
                    label: qsTr("Tip izvještaja")
                    width:  parent.width - 40
                    model: root.model
                    textRole: "title"
                    currentIndex: 0
                    onIndexChanged: {
                        setDateFieldsOpacity();
                    }
                }
                MyTextFieldH {
                    id: txtFromDate
                    label: qsTr("Od datuma")
                    text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                    inputMask: "99/99/9999"
                    width:  parent.width - 40
                    isValid: (text != "")
                    isEnabled: false
                    onDonePressed: txtToDate.setFocus()
                    Image {
                        id: imgSearch
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "../images/calendar.png"
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: if (txtFromDate.isEnabled)
                                opetDatePicker(txtFromDate)
                        }
                    }
                }
                MyTextFieldH {
                    id: txtToDate
                    label: qsTr("Do datuma")
                    text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                    inputMask: "99/99/9999"
                    width:  parent.width - 40
                    isValid: (text != "")
                    isEnabled: false
                    onDonePressed: Qt.inputMethod.hide()
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "../images/calendar.png"
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: if (txtToDate.isEnabled)
                                opetDatePicker(txtToDate)
                        }
                    }
                }
            }
        }
    }
}
