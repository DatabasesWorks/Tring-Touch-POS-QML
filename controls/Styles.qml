import QtQuick 2.1
import QtQuick.Controls 1.1

Item {
    property Component rectangle: rectangleId

    QtObject {
        id: internalSettings
        property color color: "green"
    }

    Component {
        id: rectangleId
        Rectangle { color: internalSettings.color; width: 400; height: 50 }
    }
}
