import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

import "../controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "backup"

    function _close()
    {
        stackView.pop({immediate: true});
    }

    function _save()
    {
        if (txtPath.text != "")
        {
            var ret = common.dbBackup(txtPath.text);

            if(ret)
            {
                stackView.pop({immediate: true});
            }
            else
            {
                toast.show(qsTr("Greška prilikom kreiranja backup-a baze podataka!"));
            }
        }
    }

    FileDialog {
        id:dialogFile;
        title: "Please select folder to save database backup";
        folder: shortcuts.documents;
        selectFolder: true
        onAccepted: {
            txtPath.text = common.dbPathFix(dialogFile.fileUrl)
        }
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: root
        anchors.margins: 20
        color: mStyle.colorAppBackground

        Flickable {
            id: flickArea
            width: root.width; height: root.height
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: main.width; contentHeight: main.height * 1.1
            flickableDirection: Flickable.VerticalFlick

            Column {
                id: main
                spacing: 20

                Text {
                    color: mStyle.colorLabelText
                    text: qsTr("Putanja")
                    font.pixelSize: 20
                }
                Row {
                    MyTextField {
                        id: txtPath
                        width:  backgroundRect.width / 2
                        isValid: (text != "")
                    }
                    Button {
                        width: 50
                        height: 50
                        text: "..."
                        onClicked: dialogFile.open()
                    }
                }
            }
        }
    }
}
