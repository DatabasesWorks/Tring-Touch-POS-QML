import QtQuick 2.9

Item {
    id: root

    height: 60

    property alias btnPay: rectPay
    property alias btnCustomer: rectCustomer
    property alias btnReclaim: rectReclaim

    signal selectedPayment()
    signal selectedCustomer()
    signal selectedReclaim()

    Rectangle {
        id: rectTotal
        anchors.fill: parent
        color: "transparent"
        border.color: mStyle.colorBorderExpressed
        border.width: 1

        Row{
            anchors.centerIn: parent
            spacing: 1

            Rectangle {
                id: rectPay
                antialiasing: true
                height: root.height - 4
                width: root.width/2 - 2
                color: mousePay.pressed ? "lightgrey" : mStyle.colorButton
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "../images/cash.png"
                }
                MouseArea {
                    id: mousePay
                    anchors.fill: parent
                    onClicked: root.selectedPayment();
                }
            }

            Rectangle {
                id: rectCustomer
                antialiasing: true
                height: root.height - 4
                width: root.width/4 - 2
                color: mouseCustomer.pressed ? "lightgrey" : mStyle.colorButton
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "../images/customer.png"
                }
                MouseArea {
                    id: mouseCustomer
                    anchors.fill: parent
                    onClicked: root.selectedCustomer();
                }
            }

            Rectangle {
                id: rectReclaim
                antialiasing: true
                height: root.height - 4
                width: root.width/4 - 2
                color: mouseReclaim.pressed ? "lightgrey" : mStyle.colorButton
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "../images/cash_return.png"
                }
                MouseArea {
                    id: mouseReclaim
                    anchors.fill: parent
                    onClicked: root.selectedReclaim();
                }
            }
        }
    }
}
