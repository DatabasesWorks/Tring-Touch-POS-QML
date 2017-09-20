function checkErrorCode(res)
{
    if (res > 0)
    {
         toast.show(qsTr("Greška biblioteke: ") + res);
    }
    else if (-1 == res)
    {
        toast.show(qsTr("Greška baze podataka!"));
    }
}

function setDecimalPoint(value)
{
    if (value == "")
        return 0;

    return (value.replace(",", "."));
}

function setDecimalPlaces(value, decPlaces)
{
    return Number(value.toFixed(decPlaces)).toLocaleString(Qt.locale(), 'f', decPlaces);
}

function setDecimalFormat(value)
{
    //if number is not decimal return that number
    if (value % 1 == 0)
            return value;

    return value.toLocaleString(Qt.locale(), 'f');
}

function flickAreaHorizontally(flickArea, objectInFocus)
{
    var flickableYmin = flickArea.contentY;
    var flickableYmax = flickableYmin + flickArea.height;

    var objectY = objectInFocus.y + 20;

    if ((objectY < flickableYmin) || (objectY >= flickableYmax))
    {
        flickArea.contentX = 0;
        flickArea.contentY = objectInFocus.y;
    }
}

function getComboboxSelectedItemId(combobox)
{
    if (combobox == undefined || combobox == null)
        return -1;

    if (combobox.model == undefined || combobox.model == null)
        return -1;

    if (combobox.model[combobox.currentIndex] == undefined
            || combobox.model[combobox.currentIndex] == null)
        return -1;

    return combobox.model[combobox.currentIndex].id;
}

function getComboboxSelectedItemValue(combobox)
{
    if (combobox == undefined || combobox == null)
        return -1;

    if (combobox.model == undefined || combobox.model == null)
        return -1;

    if (combobox.model[combobox.currentIndex] == undefined
            || combobox.model[combobox.currentIndex] == null)
        return -1;

    return combobox.model[combobox.currentIndex].value;
}

function showDialog(object, dialogText, dialogMode)
{
    Qt.createComponent("../controls/Dialog.qml").createObject(object, {text:dialogText, mode:dialogMode});
}
