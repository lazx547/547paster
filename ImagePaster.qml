import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Window
import QtQuick.Dialogs
import Clipboard 1.0
import GFile 1.2
Window {
    id: window
    minimumWidth: 20
    minimumHeight: 20
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    color: "#00000000"
    visible: false

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height
    readonly property real dpr:window.screen.devicePixelRatio
    property int width_:100
    property int height_:100
    property int dragX: 0
    property int dragY: 0
    property bool dragging: false
    property int x0
    property int y0
    property int bw:3
    property int thisn:-1
    property string path:"./data.ini"
    property bool lock:lock_set.checked
    property bool top:top_set.checked
    property color topic_color:"#2080f0"
    property int e:0

    function resize(){
        width=width_*win.scale
        height=height_*win.scale
    }

    GFile{
        id:file
    }

    onTopChanged: {
        flags=top?Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint:Qt.FramelessWindowHint
    }

    onThisnChanged: {
        if(Clipboard.hasImage())
            image.source=Clipboard.saveImage()
        else
            image.source=Clipboard.pasteText()
        window.visible=true
    }
    onWidthChanged: {
        if(e==Qt.LeftEdge || e==Qt.RightEdge)
        {
            win.scale=width/width_
            resize()
        }
    }
    onHeightChanged: {
        if(e==Qt.TopEdge || e==Qt.BottomEdge)
        {
            win.scale=height/height_
            resize()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        z:2
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.LeftButton|Qt.RightButton

        onWheel:(wheel)=>{
                    if(!lock)
                    {
                        if(wheel.angleDelta.y>0) win.scale+=0.05
                        else if(wheel.angleDelta.y<0)
                        {
                            if(window.width>50)  win.scale-=0.05
                        }
                        resize()
                    }
                }
        onPressed: (mouse)=>{
                       if(!lock){
                           const p = mouse
                           const b = bw; // Increase the corner size slightly
                           if (mouse.x < b) { e = Qt.LeftEdge }
                           if (mouse.x >= width - b) { e = Qt.RightEdge }
                           if (mouse.y < b) { e = Qt.TopEdge }
                           if (mouse.y >= height - b) { e = Qt.BottomEdge }
                           if(e==0)
                           {
                               dragX = mouseX
                               dragY = mouseY
                               dragging = true
                               x0=window.x
                               y0=window.y
                           }
                           else if(mouse.button!=Qt.RightButton)
                           window.startSystemResize(e);
                       }
                   }
        onReleased: (mouse)=>{
                        resize()
                        e=0
                        dragging = false
                        if(window.x==x0 && window.y==y0 && mouse.button==Qt.RightButton)
                        {
                            menu_.x=window.x+mouseX
                            menu_.y=window.y+mouseY
                            if(menu_.x+menu_.width>sys_width) menu_.x-=menu_.width
                            if(menu_.y+menu_.height>sys_height) menu_.y-=menu_.height
                            menu_.visible=true
                        }

                    }
        onPositionChanged: {
            if (dragging) {
                window.x += mouseX - dragX
                window.y += mouseY - dragY
            }
        }
    }
    Rectangle{
        id:win
        transformOrigin: Item.TopLeft
        color:"#00000000"
        scale: 1
        width: width_
        height: height_
        Image{
            property string last:"-1"
            id:image
            onStatusChanged:
            {
                if(status==Image.Error)
                {
                    if(last=="-1")
                        $load.toText(thisn)
                    else
                        source=last
                }
                else if(status==Image.Ready)
                {
                    width/=dpr
                    height/=dpr
                    width_=image.width
                    height_=image.height
                    resize()
                }
            }
        }
    }
    Window{//右键菜单窗口
        id:menu_
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 102
        height:122
        color:"transparent"
        minimumWidth: 102
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem)
                visible=false
        }
        onVisibleChanged:
        {
            if(!visible)
            {
                width=minimumWidth
            }
        }
        Rectangle{//右键菜单窗口背景
            id:menu__back
            width: menu_.width
            height:menu_.height
            border.width: 1
            border.color: "#80808080"
            transformOrigin: Item.TopLeft
        }
        Item{
            x:1
            y:1
            width: 100
            height: parent.height-2
            Cbutton{
                id:top_set
                type:1
                width: parent.width
                text: "置顶"
                checkable: true
                checked: true
                onClicked: menu_.visible=false
            }
            Cbutton{
                id:lock_set
                type:1
                y:top_set.height
                width: parent.width
                text: "锁定"
                checkable: true
                onClicked: menu_.visible=false
            }

            Cbutton{
                y:top_set.height*2
                type:1
                id:save_bu
                width: parent.width
                text:"图片另存为"
                onClicked: {
                    var s=String(image.source)
                    if(s.substring(0,1)==".")
                    {
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(0,s.indexOf("."))
                    }
                    Clipboard.saveAs(s)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*3
                type:1
                width: parent.width
                text:"复制图片路径"
                onClicked: {
                    Clipboard.copyText(image.source)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*4
                type:1
                width: parent.width
                text:"粘贴图片路径"
                onClicked: {
                    image.last=image.source
                    image.source=Clipboard.pasteText()
                    menu_.visible=false
                }
            }

            /*
            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    menu_.visible=false
                    window.visible=false
                }
            }
            Cbutton{
                y:top_set.height*6
                type:1
                width: parent.width
                text: "幽灵模式"
                onClicked: {
                    menu_.visible=false
                    sysTray.ghost()
                }
            }*/
            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu_.visible=false
                    $load.exit(thisn)
                }
            }
        }}
}
