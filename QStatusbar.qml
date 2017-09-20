import QtQuick 2.9

import "controls"

Item {
    BorderImage {
        id: footer
        visible: true
        border.bottom: 4
        source: "images/footer.png"
        anchors.fill: parent

        MyClock
        {
            height: 12
            anchors {left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter}
        }

        Text{
          height: 12
          anchors {right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter}
          font.pixelSize: 12
          text: (typeof mCashier == 'undefined' || mCashier == null) ? "" : mCashier.name
          color: "white"
          visible: stackView.visible
        }
    }
}
