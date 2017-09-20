import QtQuick 2.9
import QtQuick.Controls 1.4

Item {
    height: 300

    property alias label: fieldLabel.text
    property alias text: field.text
    property alias wrapMode: field.wrapMode

    signal focusGet()
    signal enterOrReturnPressed()
    signal donePressed()

    function setFocus()
    {
        field.forceActiveFocus();
    }

    Row
    {
        anchors.fill: parent
        spacing: 10

        Text {
            id: fieldLabel
            color: "white"
            font.pixelSize: 20
            width: (text == "") ? 0 : 180
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            font.capitalization: Font.AllUppercase
        }

        TextArea {
            id: field
            width: parent.width - fieldLabel.width - 10
            height: 300
            font.pixelSize: 20
            wrapMode: TextEdit.WrapAnywhere

            onFocusChanged:
            {
                if (focus)
                {
                    selectAll();
                    focusGet();
                }
                else
                {
                    select(0,0);
                }
            }

            Keys.onReturnPressed: {
                enterOrReturnPressed();
                donePressed();
            }
        }
    }

}
