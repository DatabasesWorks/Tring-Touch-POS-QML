import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1

Item {
    id: root

    property alias inputText: textSearch.text
    property alias placeholderText: textSearch.placeholderText
    property int timerInterval: 7000
    property bool lightBox: false
    property bool startTimerOnFocus: false
    signal textInput
    signal textClear
    signal timerEnded

    height: 60
    anchors.left: parent.left
    anchors.right: parent.right

    property color textColor: "white"

    TextField {
            id: textSearch
            anchors.fill: root
            font.pixelSize: 28

            style: TextFieldStyle {
                textColor: root.textColor
                background: Rectangle {
                    color: lightBox ? "#bfbfbf" : "#3e3e3e"
                    border.color: "gray"
                    border.width: 1
                }
                 padding.right: img.width
            }

            Behavior on visible {
                NumberAnimation{ duration: 300 }
            }

            onTextChanged: {
                timer.restart();
                root.textInput();
            }


            onFocusChanged:
            {
                if (!startTimerOnFocus)
                    return;

                if(focus)
                {
                    timer.running = true;
                }
                else
                {
                    timer.running = false;
                }
            }

            onVisibleChanged:
            {
                if (startTimerOnFocus)
                    return;

                if(visible)
                {
                    focus = true;
                    timer.running = true;
                    textSearch.forceActiveFocus();
                }
                else
                {
                    focus = false;
                    timer.running = false;
                    textSearch.focus = false;
                }
            }

            Image {
                id: img
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/x.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textSearch.text = "";
                        root.textInput();
                    }

                }
            }
        }


    Timer {
           id: timer; running: false; interval: root.timerInterval; repeat: false
           onTriggered:
           {
               root.timerEnded();
           }
       }
}
