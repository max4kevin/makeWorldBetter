import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: resultsZone

    Rectangle {
        id: resultTitle
        width: parent.width
        height: 30
        color: mainWindow.backgroundColor

        Row {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Text {
                width: parent.width/3
                horizontalAlignment:  Text.AlignHCenter
                color: mainWindow.textColor
                clip: true
                font.bold: true
                text: qsTr("Name")
            }

            Text {
                width: parent.width/3
                horizontalAlignment:  Text.AlignHCenter
                color: mainWindow.textColor
                clip: true
                font.bold: true
                text: qsTr("Value")
            }

            Text {
                width: parent.width/3
                horizontalAlignment:  Text.AlignHCenter
                color: mainWindow.textColor
                clip: true
                font.bold: true
                text: qsTr("Reference value")
            }
        }
    }

    ListView {
        id: resultsList
        width: parent.width
//        anchors.topMargin: rightPanel.spacing
        anchors.top: resultTitle.bottom
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical
        spacing: rightPanel.spacingValue
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: Row {
            id: resultLine
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            Text {
                id: nameText
                width: parent.width/3
                leftPadding: rightPanel.spacing
                clip: true
                color: mainWindow.textColor
                text: name
            }

            Text {
                id: valueText
                width: parent.width/3
                horizontalAlignment: Text.AlignHCenter
                clip: true
                color: mainWindow.textColor
                text: value
            }

            Text {
                id: referenceText
                width: parent.width/3
                horizontalAlignment: Text.AlignHCenter
                clip: true
                color: mainWindow.textColor
                text: reference
            }
        }

        model: ListModel {
            id: results
        }

        ScrollBar.vertical: CustomScrollBar {
               visible: parent.width !== 0
        }

        Connections {
            target: backEnd
            onResultAdded: {
                results.append({name: resultName, value: "", reference: resultReference})
                console.log("Result \""+resultName+"\" added")
            }

            onResultUpdated: {
                for (var i = 0; i < results.count; ++i)
                {
                    if (results.get(i).name === resultName)
                    {
                        results.get(i).reference = resultReference
                        results.get(i).value = resultValue
                        return
                    }
                }
                console.log("Error: Result \""+resultName+"\" not found in table")
            }

            onClearTables: {
                results.clear()
            }
        }
    }
    CustomButton {
        id: storeResultsBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: qsTr("Store results")
        enabled: workZone.isReady

        //TODO: Custom store path
        onClicked: {
            workZone.saveData()
        }
    }
}
