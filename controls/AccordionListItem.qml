import QtQuick 2.9

Item {
    id: container
    focus: true

    property int fontSize: 20
    property color fontColor: "white"

    property string text: "NOT SET"

    property int itemIndex: -1

    property bool selected: false
    property bool selectable: false
    property int textIndent: 0
    signal clicked
    signal pressAndHold

    width: 360
    height: 64
    clip: true
    onSelectedChanged: selected ? state = 'selected' : state = ''

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#32b4e5"
        visible: mouseArea.pressed
    }

    Text {
        id: itemText
        font.pixelSize: container.fontSize
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            topMargin: 4
            bottomMargin: 4
            leftMargin: 8 + textIndent
            rightMargin: 8
            verticalCenter: container.verticalCenter
        }

        color: container.fontColor
        elide: Text.ElideRight
        text: container.text
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#32b4e5"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked:{
            container.clicked();
        }
        onPressAndHold:{
            container.pressAndHold();
        }
    }

//    states: [
//        State {
//            name: 'pressed'; when: mouseArea.pressed
//            PropertyChanges { target: rect; color: "#32b4e5";}
//        },
//        State {
//            name: 'selected'
//            PropertyChanges { target: rect; color: "#32b4e5";}
//        },
//        State {
//            name: 'active';
//            PropertyChanges { target: rect; color: "#32b4e5"; }
//        },
//        State {
//            name: '';
//            PropertyChanges { target: rect; color: "transparent"; }
//        }
//    ]
}
