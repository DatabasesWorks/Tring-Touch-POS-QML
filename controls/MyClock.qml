import QtQuick 2.9

Item {
    id: clock

    property string hours: "00"
    property string minutes: "00"
    property string day: "00"
    property string month: "00"
    property string year: "00"
    property alias dateTime: txtClock.text

    function timeChanged()  {
        dateTime = getDateTime()
//            var date = new Date;
//            hours = pad(date.getHours());
//            minutes = pad(date.getMinutes());
//            day = pad(date.getDay());
//            month = pad(date.getMonth());
//            year = pad(date.getYear());
       }

    function getDateTime()
    {
        var d = new Date();
        var dt = d.toLocaleDateString();
        dt += " " + d.getHours() + ":" + d.getMinutes();
        return dt;
    }

    function pad(value) {
        if(value < 10) {
            return '0' + value;
        } else {
            return value;
        }
    }

    //FontLoader { id: localFont; source: "../fonts/RobotoCondensed-Light.ttf" }

    Timer  {
           interval: 100; running: true; repeat: true;
           onTriggered: clock.timeChanged()
    }

    Text {
        id: txtClock
        anchors.verticalCenter: parent.verticalCenter
        //text: getDateTime();//clock.hours + ":" + clock.minutes
        //font { family: localFont.name; pointSize: 12 }
        font.pixelSize: 12
        font.capitalization: Font.AllUppercase
        color: "white"
    }
}
