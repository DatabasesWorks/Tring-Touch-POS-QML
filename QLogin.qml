import QtQuick 2.9
import QtQuick.Controls 2.2
import "./controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "login"

    property alias text: txtPassword.text

    Component.onCompleted:
    {
        txtPassword.field.forceActiveFocus();
    }

    function login()
    {
        if (cashierCommon.checkCashier(txtPassword.text))
        {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("QMenu.qml"), immediate:true})
        }
    }

    function _logout()
    {
        Qt.quit();
    }

    Row {
        id: row
        spacing: 16
        anchors.centerIn: parent

        MyTextField {
            id: txtPassword
            placeholderText: " " + qsTr("Upišite šifru")
            height: 50
            width: 400
            maximumLength : 6
            echoMode: TextInput.Password
            onEnterOrReturnPressed: root.login();

            Image {
                id: img
                source: mouseImg.pressed ? "../images/login_red.png" : "../images/login.png"
                anchors { top: txtPassword.top; right: txtPassword.right;  } //margins: parent.paddingMedium

                MouseArea {
                    id: mouseImg
                    anchors.fill: img
                    hoverEnabled: true
                    onClicked: root.login()
                }
            }
        }
    }


}
