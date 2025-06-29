import QtQuick
import QtQuick.Controls
import GFile 1.2
import Clipboard 1.0

Item {
    property var paster:Qt.createComponent("./Paster.qml")
    property var menuItem:Qt.createComponent("./PMenuItem.qml")
    property var objs:[]
    function create(){
        if(Clipboard.pasteText()=="")
            return
        objs.push(paster.createObject())
        var n=objs.length-1
        objs[n].thisn=n
        // var newItem = menuItemComponent.createObject($menu, {thisn: n});
        // $menu.insertItem(1, newItem);
    }

    function exit(n)
    {
        objs[n].destroy()
        for(var i=n;i<objs.length-1;i++)
        {
            objs[i]=objs[i+1]
            objs[i].thisn--
        }
        objs.pop()
    }

    function setVisible(n,set)
    {
        objs[n].visible=set
    }

    Component {
        id: menuItemComponent
        MenuItem {
            property int thisn
            text: thisn
            onTriggered:{
                $load.setVisible(thisn,checked)
            }
        }
    }
    GFile{
        id:file
    }

    Component.onCompleted: {
    }
}
