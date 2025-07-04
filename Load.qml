import QtQuick
import QtQuick.Controls
import GFile 1.2
import Clipboard 1.0

Item {
    property var paster:Qt.createComponent("./Paster.qml")
    property var imagePaster:Qt.createComponent("./ImagePaster.qml")
    property var menuItem:Qt.createComponent("./PMenuItem.qml")
    property var shoter:Qt.createComponent("./ScreenShot.qml")
    property var shotObj
    property var objs:[]
    function create(){
        objs.push(imagePaster.createObject())
        var n=objs.length-1
        objs[n].thisn=n
        // var newItem = menuItemComponent.createObject($menu, {thisn: n});
        // $menu.insertItem(1, newItem);
    }
    function toImage(n){

    }

    function toText(n){
        exit(n)
        objs.push(paster.createObject())
        n=objs.length-1
        objs[n].thisn=n
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

    function shot(){
        var a=Clipboard.shot()
        shotObj=shoter.createObject()
        shotObj.name=a
    }

    function endShot(){
        shotObj.destroy()
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
