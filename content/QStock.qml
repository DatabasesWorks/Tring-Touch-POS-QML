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

    property string _name : "stock"

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function getValue(role, value)
    {
        if (role == "priceWithTax" || role == "priceWithoutTax")
            return JsCommon.setDecimalPlaces(value, 2);
        else if (role == "input" || role == "output" || role == "currentQuantity")
            return JsCommon.setDecimalPlaces(value, 3);
        else
            return value;
    }

    function getAlignment(role)
    {
        if (role == "name")
            return Text.AlignLeft;
        else
            return Text.AlignHCenter;
    }

    function search(searchText)
    {
        tableStock.model = stockCommon.getStock(searchText);
    }

    /* background */
    Rectangle {
            id: rectBackground
            anchors.fill: root
            anchors.margins: 20
            color: mStyle.colorAppBackground

            Column {
                anchors.fill: parent

                Search  {
                   id: txtSearch
                   width: rectBackground.width
                   height: 50
                   timerInterval: 100
                   onTimerEnded: search(inputText)
                }

                TableView {
                    id: tableStock
                    model: stockCommon.getStock("")
                    width: rectBackground.width
                    height: parent.height - 50

                    TableViewColumn {
                        role: "itemId"
                        title: qsTr("Šifra")
                        width: tableStock.width / 16
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "name"
                        title: qsTr("Naziv")
                        width: tableStock.width / 4
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "unitOfMeasure"
                        title: qsTr("JM")
                        width: tableStock.width / 16
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "priceWithTax"
                        title: qsTr("Cijena sa PDV")
                        width: tableStock.width / 8
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "priceWithoutTax"
                        title: qsTr("Cijena bez PDV")
                        width: tableStock.width / 8
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "input"
                        title: qsTr("Ulaz")
                        width: tableStock.width / 8
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "output"
                        title: qsTr("Izlaz")
                        width: tableStock.width / 8
                        horizontalAlignment: Text.AlignHCenter
                    }
                    TableViewColumn {
                        role: "currentQuantity"
                        title: qsTr("Stanje")
                        width: tableStock.width / 8
                        horizontalAlignment: Text.AlignHCenter
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
                            width: parent.width
                            anchors.margins: 4
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                            text: getValue(styleData.role, styleData.value)
                            color: mStyle.colorAppBackground
                            font.pixelSize: 20
                            horizontalAlignment: getAlignment(styleData.role)
                        }
                        Rectangle {
                           anchors.top: parent.top
                           anchors.left: parent.left
                           anchors.bottom: parent.bottom
                           width: 1
                           color: "lightgrey"
                       }
                    }

                    frameVisible: true
                    headerVisible: true
                    sortIndicatorVisible: true
                    alternatingRowColors: true
                }
            }
        }
}
