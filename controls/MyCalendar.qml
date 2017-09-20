import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1

Item {
    id: root
    anchors.fill: parent
    property color buttonColor: "#32b4e5"
    property alias selectedDate: calendar.selectedDate

    Component.onCompleted:
    {
        toolbar.enabled = false;
    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    PropertyAnimation { target: root; property: "opacity";
                                  duration: 400; from: 0; to: 1;
                                  easing.type: Easing.InOutQuad ; running: true }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6

        MouseArea {
            anchors.fill: parent
        }
    }

    SystemPalette {
        id: systemPalette
    }

    Column {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Calendar {
            id: calendar
            width: 310
            height: 350
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter
           // anchors.verticalCenter: root.horizontalCenter
            //width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
            //height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
            frameVisible: true
            weekNumbersVisible: false
            selectedDate: new Date()//new Date(2016, 0, 1)
            focus: true

            style: CalendarStyle {
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"

                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10
            Rectangle {
                height: 50
                width: 150
                color: mouseAccept.pressed ? "white" : root.buttonColor

                Text {
                    anchors.centerIn: parent
                    text: qsTr("Prihvati")
                    color: mouseAccept.pressed ? "lightgrey" : "white"
                    font.pixelSize: 24
                }

                MouseArea {
                    id: mouseAccept
                    anchors.fill: parent;
                    onClicked:
                    {
                        root.parent._setDate(selectedDate);
                        root.destroy();
                    }
                }
            }
            Rectangle {
                height: 50
                width: 150
                color: mouseCancel.pressed ? "white" : root.buttonColor

                Text {
                    anchors.centerIn: parent
                    text: qsTr("Odustani")
                    color: mouseCancel.pressed ? "lightgrey" : "white"
                    font.pixelSize: 24
                }

                MouseArea {
                    id: mouseCancel
                    anchors.fill: parent;
                    onClicked: {
                        root.destroy();
                        }
                }
            }
        }
    }
}
