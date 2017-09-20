import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import TDocument 1.0
import TDocumentItem 1.0

import "../controls"
import "../js/jsCommon..js" as JsCommon

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "input"

    property TDocumentItem pDocumentItem

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function setInputFocus()
    {
        txtInput.text = "";
        txtInput.field.forceActiveFocus();
    }

    function setStockItem()
    {
        pDocumentItem.input = JsCommon.setDecimalPoint(txtInput.text);
        pDocumentItem.priceWithTax = JsCommon.setDecimalPoint(txtPrice.text);
        pDocumentItem.unitOfMeasure = txtUnit.text;
    }

    function _new()
    {
        if (isValid())
        {
             setStockItem();

            if (stockCommon.insertIntoStock(pDocumentItem))
            {
                itemCommon.updateItemById(pDocumentItem.itemId, pDocumentItem.unitOfMeasure, pDocumentItem.priceWithTax);
                //listStock.model = stockCommon.getStock(txtSearch.inputText);
                setInputFocus();
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

    function isValid()
    {
        return (pDocumentItem != null && txtInput.text != "" && txtPrice.text != "")
    }

    function search(searchText)
    {
        tableStock.model = stockCommon.getStock(searchText);
    }

    function getValue(role, value)
    {
        if (role == "currentQuantity")
            return JsCommon.setDecimalPlaces(value, 3);
        else
            return value;
    }

    /* background */
    Rectangle {
            id: rectBackground
            anchors.fill: root
            anchors.margins: 20
            color: mStyle.colorAppBackground

            Flickable {
                id: flickArea
                width: root.width; height: root.height
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: main.width; contentHeight: main.height * 1.1
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Column {
                    id: main
                    width: parent.width
                    spacing: 20

                    Column
                    {
                        Search
                        {
                           id: txtSearch
                           width: rectBackground.width
                           height: 50
                           timerInterval: 100
                           onTimerEnded: search(inputText)
                        }

                        /* stock list */
                        TableView {
                            id: tableStock
                            model: stockCommon.getStock(txtSearch.inputText)
                            width: rectBackground.width
                            height: 250
                            frameVisible: false
                            headerVisible: false
                            sortIndicatorVisible: true
                            alternatingRowColors: true

                            TableViewColumn {
                                role: "name"
                                title: "Naziv"
                                width: rectBackground.width - 340
                                horizontalAlignment: Text.AlignLeft
                            }
                            TableViewColumn {
                                role: "currentQuantity"
                                title: "Stanje"
                                width: 320
                                horizontalAlignment: Text.AlignRight
                            }

                            rowDelegate: Rectangle {
                               height: 40
                               SystemPalette {
                                  id: myPalette;
                                  colorGroup: SystemPalette.Active
                               }
                               color: {
                                  var baseColor = styleData.alternate?myPalette.alternateBase:myPalette.base
                                  return styleData.selected?myPalette.highlight:baseColor
                               }
                            }

                            itemDelegate: Item {
                                Text {
                                    anchors.leftMargin: 30
                                    anchors.rightMargin: 20
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    elide: Text.ElideRight
                                    text: getValue(styleData.role, styleData.value)
                                    color: "#666"
                                    font.pixelSize: 20
                                    horizontalAlignment: styleData.textAlignment
                                }
                            }

                            onClicked:
                            {
                                pDocumentItem = stockCommon.getStockItem(model, row);
                                setInputFocus();
                            }
                        }

                        Rectangle
                        {
                            id: tectDisplay
                            width: rectBackground.width
                            anchors.rightMargin: 5
                            height: 50
                            color: "#3e3e3e"
                            border.color: mStyle.colorBorderExpressed
                            border.width: 1

                            Text {
                                id: txtName
                                color: mStyle.colorLabelText
                                font.pixelSize: 20
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 30
                                width: parent.width / 2 - 30 //margine
                                elide: Text.ElideRight
                                text: pDocumentItem != null ? pDocumentItem.name : ""
                            }

                            Text {
                                id: txtSum
                                color: mStyle.colorLabelText
                                font.pixelSize: 20
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                width: parent.width / 2 - 30
                                anchors.rightMargin: 40
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignRight
                                text: pDocumentItem != null ? JsCommon.setDecimalPlaces(pDocumentItem.currentQuantity, 3) : ""
                            }
                        }
                    }

                    MyTextFieldH {
                        id: txtInput
                        label: qsTr("Količina")
                        width:  parent.width - 40
                        validator: DoubleValidator {decimals: 3; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        isValid: (text != "" && text != "0")
                        onDonePressed: txtPrice.setFocus()
                    }

                    MyTextFieldH {
                        id: txtPrice
                        label: qsTr("Cijena")
                        validator: DoubleValidator {bottom: 0; decimals: 2; notation: DoubleValidator.StandardNotation}
                        inputMethodHints: Qt.ImhPreferNumbers
                        width: parent.width - 40
                        isValid: (text != "" && JsCommon.setDecimalPoint(text) != JsCommon.setDecimalPoint(0.00))
                        text: pDocumentItem != null ? JsCommon.setDecimalPlaces(pDocumentItem.priceWithTax, 2) : ""
                        onDonePressed: txtUnit.setFocus()
                    }

                    MyTextFieldH {
                        id: txtUnit
                        label: qsTr("JM")
                        width: parent.width - 40
                        text: pDocumentItem != null ? pDocumentItem.unitOfMeasure : ""
                        onDonePressed: Qt.inputMethod.hide()
                    }
                }
            }
        }
}
