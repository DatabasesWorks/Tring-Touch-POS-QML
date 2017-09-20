import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "nonfiscalreports"

    property var fromDate
    property var toDate

    property MyTextField dataFiled

    function _print()
    {
        getPeriod();

        var res;
        if(0 == model[cmbReports.currentIndex].id)
        {
            res = common.reportItemsText(fromDate, toDate);
        }
        else if (1 == model[cmbReports.currentIndex].id)
        {
            res = common.reportCashiersText(fromDate, toDate);
        }
        else if (2 == model[cmbReports.currentIndex].id)
        {
            res = common.reportGroupsText(fromDate, toDate);
        }
        else if (3 == model[cmbReports.currentIndex].id)
        {
            res = common.reportSubgroupsText(fromDate, toDate);
        }
        else if (4 == model[cmbReports.currentIndex].id)
        {
            res = common.reportCustomersText(fromDate, toDate);
        }
        else if (5 == model[cmbReports.currentIndex].id)
        {
            res = common.reportStockPlus();
        }
        else if (6 == model[cmbReports.currentIndex].id)
        {
            res = common.reportStockMinus();
        }

        Qt.createComponent("../controls/TextPreview.qml").createObject(root,
                                                              {title:cmbReports.currentText,
                                                                  text:res});
        JsCommon.checkErrorCode(res);
    }

    function _printText(text)
    {
        if (text != "")
        {
            var res = common.tflNonfiscalText(text);
            JsCommon.checkErrorCode(res);
            return res;
        }
    }

    // define plain JS object list
    property var model: [
        { title: qsTr("Izvještaj po artikalima"), id: 0 },
        { title: qsTr("Izvještaj po kasirima"), id: 1 },
        { title: qsTr("Izvještaj po grupama"), id: 2 },
        { title: qsTr("Izvještaj po podgrupama"), id: 3 },
        { title: qsTr("Izvještaj po kupcima"), id: 4 },
        { title: qsTr("Lager - na stanju"), id: 5 },
        { title: qsTr("Lager - nema na stanju"), id: 6 }
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
        fromDate = getDateFromText(txtFromDate.text);
        toDate = getDateFromText(txtToDate.text);
    }

    function getDateFromText(text)
    {
        var newDate = new Date();
        newDate.setDate(text.substr(0, 2));
        newDate.setMonth(text.substr(3, 2) - 1);
        newDate.setFullYear(text.substr(6, 4));
        return newDate;
    }

    function opetDatePicker(field)
    {
        dataFiled = field;
        var newDate = getDateFromText(field.text);
        Qt.createComponent("../controls/MyCalendar.qml").createObject(root, {selectedDate:newDate});
    }

    function setDateFieldsOpacity()
    {
        var id = model[cmbReports.currentIndex].id;

        if (txtFromDate != null && txtToDate != null)
            txtFromDate.isEnabled = txtToDate.isEnabled = !(id == 5 || id == 6);
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.margins: 20
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

                MyComboBoxH {
                    id: cmbReports
                    label: qsTr("Tip izvještaja")
                    width: parent.width - 40
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
                    width: parent.width - 40
                    isValid: (text != "")
                    onDonePressed: txtToDate.setFocus()
                    Image {
                        id: imgSearch
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        source: "../images/calendar.png"
                        MouseArea {
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
                    width: parent.width - 40
                    isValid: (text != "")
                    onDonePressed: Qt.inputMethod.hide()
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                                                anchors.rightMargin: 5
                        source: "../images/calendar.png"
                        MouseArea  {
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
