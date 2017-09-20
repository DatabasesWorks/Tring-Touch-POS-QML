import QtQuick 2.9

Item {
    id: dialogComponent

    property alias text: title.text
    property string mode

    property string activeControl

    anchors.fill: parent

    Component.onCompleted:
    {
        toolbar.enabled = false;
    }
    Component.onDestruction:
    {
        toolbar.enabled = true;
    }

    PropertyAnimation { target: dialogComponent; property: "opacity";
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

    Rectangle {
        id: dialogWindow
        width: parent.width * 4/5
        height: title.height + buttons.height + 50

        radius: 10
        anchors.centerIn: parent

        Text {
            id: title
            y: dialogWindow.height/2 - height
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            font.pixelSize: 20
        }

        Rectangle{
                id: buttons
                anchors.top: title.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                width: parent.width

                    Row {
                        anchors.centerIn: buttons
                        spacing: 10

                        Rectangle {
                            id: btnYes
                            width: 160;
                            height: buttons.height;
                            color: mouseYes.pressed ? "lightgrey" : "#4BBDE8"
                            radius: 15;
                            anchors.verticalCenterOffset: 144;
                            anchors.horizontalCenterOffset: 0

                            MouseArea {
                                id: mouseYes
                                anchors.fill: parent;
                                onClicked:
                                {
                                    if (mode == "delete") {
                                        stackView.__currentItem._dDelete();
                                    }
                                    else if (mode == "new"){
                                        stackView.__currentItem._dNew();
                                    }
                                    else if (mode == "saveOrPop" || mode == "saveOrNew"){
                                       stackView.__currentItem._dSave();
                                    }

                                    dialogComponent.destroy();
                                }
                            }
                            Text {
                                id: txtYes
                                text: qsTr("Da")
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 20
                                }
                            }

                        Rectangle {
                            id: btnNo
                            width: 160;
                            height: buttons.height;
                            color: mouseNo.pressed ? "lightgrey" : "#4BBDE8"
                            radius: 15;
                            //border.color: "#ADE1F4"
                            //border.width: 2;
                            anchors.verticalCenterOffset: 144;
                            anchors.horizontalCenterOffset: 0

                            MouseArea {
                                id: mouseNo
                                anchors.fill: parent;
                                onClicked:
                                {
                                    if (mode == "saveOrPop")
                                    {
                                        stackView.pop({immediate: true});
                                    }
                                    else if (mode == "saveOrNew"){
                                        stackView.__currentItem._newReceipt();
                                    }

                                    dialogComponent.destroy();

                                }
                            }
                            Text {
                                id: txtNo
                                text: qsTr("Ne")
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 20
                                }
                            }
                    }
                }
        }
}
