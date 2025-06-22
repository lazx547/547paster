import QtQuick
import QtQuick.Controls

MenuItem {
    property int thisn:-1
    checkable: true
    checked: true
    onTriggered: $load.setVisible(thisn,checked)
}
