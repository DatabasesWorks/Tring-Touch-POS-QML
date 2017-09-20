import QtQuick 2.9
import QtQuick.Controls.Styles 1.4

Item  {
    property color colorAppBackground: "#212126"

    property color colorToolbarButton: "transparent"
    property color colorToolbarButtonPressed: "darkgrey"

    property color colorLabelText: "white"

    property color colorListHighlight: "#32b4e5"

    property color colorBorderValid: "#333"
    property color colorBorderInvalid: "red"
    property color colorBorderExpressed: "#32b4e5"

    property color colorFieldTextValid: "black"
    property color colorFieldBackgroundDisabled: "grey"

    property color colorButton: "#32b4e5"
    property color colorButtonPressed: "white"
    property color colorButtonText: "white"
    property color colorButtonTextPressed: "lightgrey"

    property alias textFieldValid: textFieldValid
    property alias textFieldInvalid: textFieldInvalid
    property alias textFieldDisabled: textFieldDisabled

    property alias comboBoxValid: comboBoxValid
    property alias comboBoxInvalid: comboBoxInvalid

    SystemPalette { id: sysPalette; colorGroup: SystemPalette.Active }

    Component {
        id: textFieldValid
        TextFieldStyle {
            textColor: colorFieldTextValid
                    background: Rectangle {
                        implicitHeight: 50
                        border.color: colorBorderValid
                        border.width: 1
                    }
        }
    }

    Component {
        id: textFieldInvalid
        TextFieldStyle {
            textColor: colorFieldTextValid
                    background: Rectangle {
                        implicitHeight: 50
                        border.color: colorBorderInvalid
                        border.width: 1
                    }
        }
    }

    Component {
        id: textFieldDisabled
        TextFieldStyle {
            textColor: colorFieldTextValid
                    background: Rectangle {
                        implicitHeight: 50
                        border.color: colorBorderValid
                        border.width: 1
                        color: colorFieldBackgroundDisabled
                    }
        }
    }

    Component {
        id: comboBoxValid
        ComboBoxStyle {
             label:  Item {
                     anchors.fill: parent
                     Text {
                       anchors.verticalCenter: parent.verticalCenter
                       font.pointSize: 28
                       text: control.currentText
                       color: (control.pressed || control.activeFocus) ? sysPalette.highlightedText : sysPalette.buttonText
                    }
                     ScrollArrow {
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.right: parent.right
                         anchors.rightMargin: 6
                         implicitWidth: 12
                         implicitHeight: 6
                         rotation: control.pressed ? 0 : 180
                         //arrowColor: (control.activeFocus && !control.editable) ?  sysPalette.highlightedText : sysPalette.buttonText
                     }
             }
             background: Rectangle {
                 implicitHeight: 50
                 border.color: colorBorderValid
                 border.width: 1
                 color: (control.pressed || control.activeFocus) ? sysPalette.highlight : sysPalette.button
             }
       }
   }
    Component {
        id: comboBoxInvalid
        ComboBoxStyle {
             label:  Item {
                     anchors.fill: parent
                     Text {
                       anchors.verticalCenter: parent.verticalCenter
                       font.pointSize: 28
                       text: control.currentText
                       color: (control.pressed || control.activeFocus) ? sysPalette.highlightedText : sysPalette.buttonText
                    }
                     ScrollArrow {
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.right: parent.right
                         anchors.rightMargin: 6
                         implicitWidth: 12
                         implicitHeight: 6
                         rotation: control.pressed ? 0 : 180
                         //arrowColor: (control.activeFocus && !control.editable) ?  sysPalette.highlightedText : sysPalette.buttonText
                     }
             }
             background: Rectangle {
                 implicitHeight: 50
                 border.color: colorBorderInvalid
                 border.width: 1
                 color: (control.pressed || control.activeFocus) ? sysPalette.highlight : sysPalette.button
             }
       }
   }
}


