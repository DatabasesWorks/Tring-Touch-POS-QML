import QtQuick 2.9

Item {

    function setCustomTitle(title)
    {
        recMainTitle.titleText = title;
    }

    function setCustomSubtitle(subtitle)
    {
        recMainTitle.subtitleText = subtitle;
    }

    function setTitle(_name){
        if (_name == "login" || _name == "menu")
        {
            txtTitle.text = "TRING.TOUCH.POS";
            txtSubtitle.text = "v" + common.getVersion();
        }
        else if (_name == "item" || _name == "itemedit")
        {
            txtTitle.text = qsTr("Artikli");
            txtSubtitle.text = "";
        }
        else if (_name == "group" || _name == "groupedit")
        {
            txtTitle.text = qsTr("Grupe");
            txtSubtitle.text = "";
        }
        else if (_name == "customer" || _name == "customeredit")
        {
            txtTitle.text = qsTr("Komitenti");
            txtSubtitle.text = "";
        }
        else if (_name == "subgroup" || _name == "subgroupedit")
        {
            txtTitle.text = qsTr("Podgrupe");
            txtSubtitle.text = "";
        }
        else if (_name == "tax" || _name == "taxedit")
        {
            txtTitle.text = qsTr("Porezi");
            txtSubtitle.text = "";
        }
        else if (_name == "settingsedit")
        {
            txtTitle.text = qsTr("Postavke");
            txtSubtitle.text = "";
        }
        else if (_name == "receipt")
        {
            txtTitle.text = qsTr("Snimljeni računi");
            txtSubtitle.text = "";
        }
        else if (_name == "fiscalreports")
        {
            txtTitle.text = qsTr("Fiskalni izvještaji");
            txtSubtitle.text = "";
        }
        else if (_name == "nonfiscalreports")
        {
            txtTitle.text = qsTr("Nefiskalni izvještaji");
            txtSubtitle.text = "";
        }
        else if (_name == "payinout")
        {
            txtTitle.text = qsTr("Uplata/Isplata");
            txtSubtitle.text = "";
        }
        else if (_name == "nonfiscaltext")
        {
            txtTitle.text = qsTr("Nefiskalni tekst");
            txtSubtitle.text = "";
        }
        else if (_name == "duplicates")
        {
            txtTitle.text = qsTr("Duplikati");
            txtSubtitle.text = "";
        }
        else if (_name == "cashier")
        {
            txtTitle.text = qsTr("Kasiri");
            txtSubtitle.text = "";
        }
        else if (_name == "backup")
        {
            txtTitle.text = qsTr("Pohrana baze podataka");
            txtSubtitle.text = "";
        }
        else if (_name == "stock")
        {
            txtTitle.text = qsTr("Lager lista");
            txtSubtitle.text = "";
        }
        else if (_name == "input")
        {
            txtTitle.text = qsTr("Ulazne kalkulacije");
            txtSubtitle.text = "";
        }
        else if (_name == "itemcard")
        {
            txtTitle.text = qsTr("Kartica artikala");
            txtSubtitle.text = "";
        }
        else if (_name == "document")
        {
            txtTitle.text = qsTr("Dokumenti");
            txtSubtitle.text = "";
        }
        else if (_name == "admin")
        {
            txtTitle.text = qsTr("Administracija");
            txtSubtitle.text = "";
        }
    }

    function setToolbar(_name){
        if ( _name == "login" || _name == "menu")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 1
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "item" || _name == "group" || _name == "customer" || _name == "subgroup"
                || _name == "cashier")
        {
            newItem.opacity = 1
            searchItem.opacity = 1
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "tax" || _name == "receipt")
        {
            newItem.opacity = 0
            searchItem.opacity = 1
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "itemedit" || _name == "groupedit" || _name == "customeredit"
                 || _name == "subgroupedit" || _name == "cashieredit")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 1
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "taxedit")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "receiptitemedit")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "sale")
        {
            newItem.opacity = 1
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 1
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "receiptedit")
        {
            newItem.opacity = 1
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 1
            numberItem.opacity = 1
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 1
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "settingsedit")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 1
        }
        else if (_name == "fiscalreports" || _name == "nonfiscalreports")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 1
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "payinout")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 1
            payOutItem.opacity = 1
            infoItem.opacity = 0
        }
        else if (_name == "nonfiscaltext")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 1
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if (_name == "duplicates")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 1
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if ( _name == "backup")
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 1
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else if ( _name == "input")
        {
            newItem.opacity = 1
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }
        else
        {
            newItem.opacity = 0
            searchItem.opacity = 0
            saveItem.opacity = 0
            deleteItem.opacity = 0
            numberItem.opacity = 0
            listItem.opacity = 0
            logoutItem.opacity = 0
            printItem.opacity = 0
            duplicateItem.opacity = 0
            payInItem.opacity = 0
            payOutItem.opacity = 0
            infoItem.opacity = 0
        }

         setTitle(_name);
    }

    BorderImage {
        id: toolbar
        anchors.fill: parent
        visible: true
        border.bottom: 8
        source: "images/toolbar.png"

        Rectangle {
            id: backButton
            width: opacity ? 50 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: (stackView.depth > 1 ? 1 : 0)
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 50
            radius: 50
            color: backmouse.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/back.png"
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                //anchors.margins: -10
                onClicked:
                {
                    if (stackView.visible && stackView.depth > 1)
                        stackView.currentItem._close();
                }
            }
        }

        Rectangle {
            id: logoutItem
            width: opacity ? 50 : 0
            anchors {right: parent.right; rightMargin: opacity ? 20 : 0; verticalCenter: parent.verticalCenter}
            opacity: 0
            antialiasing: true
            height: 50
            radius: 50
            color: logoutmouse.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/logout.png"
            }
            MouseArea {
                id: logoutmouse
                anchors.fill: parent
                onClicked:
                {
                    stackView.currentItem._logout();
                }
            }
        }

        Rectangle {
            id: newItem
            width: opacity ? 50 : 0
            anchors {right: parent.right; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
            opacity: 0
            antialiasing: true
            height: 50
            radius: 50
            color: mouseNew.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/add.png"
            }
            MouseArea {
                id: mouseNew
                anchors.fill: parent
                onClicked:
                {
                    stackView.__currentItem._new()
                }
            }
        }
        Rectangle {
            id: searchItem
            width: opacity ? 50 : 0
            anchors {right: newItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
            opacity: 0
            antialiasing: true
            height: 50
            radius: 50
            color: mouseSearch.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/search.png"
            }
            MouseArea {
                id: mouseSearch
                anchors.fill: parent
                //anchors.margins: -10
                onClicked:
                    stackView.__currentItem._search()
            }
        }

        Rectangle {
            id: saveItem
            width: opacity ? 50 : 0
            anchors {right: searchItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
            opacity: 0
            antialiasing: true
            height: 50
            radius: 50
            color: mouseSave.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/save.png"
            }
            MouseArea {
                id: mouseSave
                anchors.fill: parent
                onClicked:
                    stackView.__currentItem._save();
            }
        }

        Rectangle {
          id: infoItem
          width: opacity ? 50 : 0
          anchors {right: saveItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: infoMouse.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              id: imgY
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/info.png"
          }
          MouseArea {
              id: infoMouse
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._info();
          }
      }

        Rectangle {
          id: deleteItem
          width: opacity ? 50 : 0
          anchors {right: saveItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: deleteMouse.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/delete.png"
          }
          MouseArea {
              id: deleteMouse
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._delete();
          }
      }

        Rectangle {
          id: numberItem
          width: opacity ? 50 : 0
          anchors {right: deleteItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mouseNumber.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/order.png"
          }
          MouseArea {
              id: mouseNumber
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._setNumber();
          }
      }

        Rectangle {
          id: listItem
          width: opacity ? 50 : 0
          anchors {right: deleteItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mouseList.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/list_w.png"
          }
          MouseArea {
              id: mouseList
              anchors.fill: parent
              onClicked:
                   stackView.__currentItem._getlist();
          }
      }

        Rectangle {
          id: printItem
          width: opacity ? 50 : 0
          anchors {right: numberItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mousePrint.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/print_w.png"
          }
          MouseArea {
              id: mousePrint
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._print();
          }
      }

        Rectangle {
          id: duplicateItem
          width: opacity ? 50 : 0
          anchors {right: printItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mouseDuplicate.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/duplicate.png"
          }
          MouseArea {
              id: mouseDuplicate
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._duplicate();
          }
      }

        Rectangle {
          id: payOutItem
          width: opacity ? 50 : 0
          anchors {right: parent.right; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mousePayOut.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/drawer_out.png"
          }
          MouseArea {
              id: mousePayOut
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._payOut();
          }
      }

        Rectangle {
          id: payInItem
          width: opacity ? 50 : 0
          anchors {right: payOutItem.left; rightMargin: opacity ? 10 : 0; verticalCenter: parent.verticalCenter}
          opacity: 0
          antialiasing: true
          height: 50
          radius: 50
          color: mousePayIn.pressed ? mStyle.colorToolbarButtonPressed : mStyle.colorToolbarButton
          Image {
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: "images/drawer_in.png"
          }
          MouseArea {
              id: mousePayIn
              anchors.fill: parent
              onClicked:
                  stackView.__currentItem._payIn();
          }
      }

        Rectangle {
            id: recMainTitle
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            property alias titleText : txtTitle.text
            property alias subtitleText: txtSubtitle.text

            Column  {
               anchors.verticalCenter: parent.verticalCenter
               Text{
                 id: txtTitle
                 font.pixelSize: 38
                 font.capitalization: Font.AllUppercase
                 color: "white"
               }
               Text{
                 id: txtSubtitle
                 font.pixelSize: 12
                 color: "white"
               }
            }
        }
    }
}
