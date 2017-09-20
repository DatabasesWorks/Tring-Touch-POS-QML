import QtQuick 2.9

Rectangle {
    id: root
    color: "transparent"
    width: parent.width
    height: 50

    //vidljivost se smanjenju sa povecanje x-a
    opacity: (width - x) / width

    property alias title: txtTitle.text
    property alias number: txtAmount.text
    property color lineColor: "#32b4e5"
    property color textColor: "white"
    property bool isPressed: false
    signal clickItem
    signal pressItem
    signal slideRight
    signal slideLeft

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        visible: mouseRoot.pressed
        color: Qt.darker("#3e3e3e", 1.5)
    }

   Text {
        id: txtTitle
        color: textColor
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.rightMargin: 5
        width: parent.width * 0.75
        elide: Text.ElideRight

    }
    Text {
        id: txtAmount
        color: textColor
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.leftMargin: 5
        width: parent.width * 0.25
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }
    Rectangle {
        id: rectLine
        anchors.right: root.right
        anchors.left: root.left
        height: 1
        color: lineColor
    }
    MouseArea {
        id:mouseRoot
        property variant previousPosition
        anchors.fill:  root
        drag.target: root
        drag.axis: Drag.XAxis
        drag.minimumX: - (root.width - 50) //0
        drag.maximumX: root.width - 50

        onReleased: {
            if (!isPressed)
            {
                if (root.x > root.width/2)
                    root.slideRight();
                else if (root.x < (-root.width/2))
                    root.slideLeft()
            }
            isPressed = false;
            root.x = 0
        }

        onClicked: {
            root.clickItem()
        }
        onPressAndHold: {
             //zaustavi pomjeranje
            isPressed = true;
            root.pressItem();
        }
    }
}
