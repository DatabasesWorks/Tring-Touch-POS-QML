/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.9
import QtQuick.Controls 1.4

import "../controls"

Item {
    id: root

    width: parent.width
    height: parent.height

    property string _name : "customer"

    function _search()
    {
        txtSearch.visible = !txtSearch.visible
    }
    function _refreshMe()
    {
        listCustomer.model = customerCommon.getCustomers(txtSearch.inputText)
    }
    function _new()
    {
        stackView.push({item: Qt.resolvedUrl("QCustomerEdit.qml"), immediate: true})
    }
    function _close()
    {
        stackView.pop({immediate: true});
    }

    Search {
        id: txtSearch
        visible: false
        onTextInput: listCustomer.model = customerCommon.getCustomers(txtSearch.inputText)
        onTimerEnded: {
            if (txtSearch.inputText == "")
                txtSearch.visible = false
        }
    }

    ListView {
        id:listCustomer
        clip: true
        width: parent.width
        height: parent.height
        interactive: contentHeight > height
        y: txtSearch.visible ? txtSearch.height : 0
        model: customerCommon.getCustomers("")

        delegate: AndroidDelegate {
            id:txtTest
            text:   model.modelData.line1
            onClicked:
            {
                 stackView.push({item: Qt.resolvedUrl("QCustomerEdit.qml"),
                                properties: {pCustomer:model.modelData, isNew:false}, immediate: true})
            }
        }

        Behavior on y {
         NumberAnimation{ duration: 200 }
        }
    }
}

