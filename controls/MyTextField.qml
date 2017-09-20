import QtQuick 2.9
import QtQuick.Controls 1.4

import "../style"

Item {
    height: isSmall ? 40 : 50

    //property alias height: height
    property alias text: field.text
    property alias fontSize: field.font.pixelSize
    property alias validator: field.validator
    property alias maximumLength: field.maximumLength
    property alias inputMethodHints: field.inputMethodHints
    property alias echoMode: field.echoMode
    property alias inputMask: field.inputMask
    property alias placeholderText: field.placeholderText
    property alias field: field

    property bool isValid: true
    property bool isEnabled: true
    property bool isSmall: false

    signal focusGet()
    signal enterOrReturnPressed()
    signal enterPressed()
    signal donePressed()

    function setFocus()
    {
        field.forceActiveFocus();
    }

    TextField {
        id: field
        anchors.fill: parent
        font.pixelSize: isSmall ? 24 : 28
        enabled: isEnabled
        style: isEnabled ?
                (isValid ? mStyle.textFieldValid : mStyle.textFieldInvalid)
                : mStyle.textFieldDisabled
        onFocusChanged:
        {
            if (focus)
            {
                selectAll();
                focusGet();
            }
//            else
//            {
//                select(0,0);
//            }
        }

        Keys.onEnterPressed: {
            enterOrReturnPressed();
            enterPressed();
        }

        Keys.onReturnPressed: {
            enterOrReturnPressed();
            donePressed();
        }

        Keys.onPressed: {
            //if numpad key is pressed - doesn't work for Android
            //if (event.modifiers && Qt.KeypadModifier)
            //todo: check if numlock is ON


            //console.log("key: " + event.key);

            switch (event.key - Qt.KeypadModifier)
            {
                case Qt.Key_0:
                    keyEmitter.emitKey(Qt.Key_0);
                    event.accepted = true;
                    break;
                case Qt.Key_1:
                    keyEmitter.emitKey(Qt.Key_1);
                    event.accepted = true;
                    break;
                case Qt.Key_2:
                    keyEmitter.emitKey(Qt.Key_2);
                    event.accepted = true;
                    break;
                case Qt.Key_3:
                    keyEmitter.emitKey(Qt.Key_3);
                    event.accepted = true;
                    break;
                case Qt.Key_4:
                    keyEmitter.emitKey(Qt.Key_4);
                    event.accepted = true;
                    break;
                case Qt.Key_5:
                    keyEmitter.emitKey(Qt.Key_5);
                    event.accepted = true;
                    break;
                case Qt.Key_6:
                    keyEmitter.emitKey(Qt.Key_6);
                    event.accepted = true;
                    break;
                case Qt.Key_7:
                    keyEmitter.emitKey(Qt.Key_7);
                    event.accepted = true;
                    break;
                case Qt.Key_8:
                    keyEmitter.emitKey(Qt.Key_8);
                    event.accepted = true;
                    break;
                case Qt.Key_9:
                    keyEmitter.emitKey(Qt.Key_9);
                    event.accepted = true;
                    break;
                case Qt.Period:
                    keyEmitter.emitKey(Qt.Period);
                    event.accepted = true;
                    break;
                case Qt.Key_Comma:
                    keyEmitter.emitKey(Qt.Key_Comma);
                    event.accepted = true;
                    break;
                case Qt.Key_Period:
                    keyEmitter.emitKey(Qt.Key_Period);
                    event.accepted = true;
                    break;
                case Qt.Key_Enter:
                    enterOrReturnPressed();
                    event.accepted = true;
                    break;
            }
        }
    }

}
