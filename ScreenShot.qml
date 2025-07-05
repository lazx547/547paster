import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Clipboard 1.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    visible: true
    property string name
    onNameChanged:image.source=name

    Image{
        id:image
        anchors.fill: parent
    }

    // 半透明背景层
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "#80000000"
    }

    // 截取区域
    Rectangle {
        id: selectionRect
        color: "#20FFFFFF"
        border.color: "#2080f0"
        border.width: 1
        visible: false
    }

    // 鼠标区域
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        property point startPos

        onPressed: (mouse)=>{
                       startPos = Qt.point(mouse.x, mouse.y)
                       selectionRect.x = mouse.x
                       selectionRect.y = mouse.y
                       selectionRect.width = 0
                       selectionRect.height = 0
                       selectionRect.visible = true
                   }

        onPositionChanged: (mouse)=>{
                               if (pressed) {
                                   selectionRect.x = Math.min(startPos.x, mouse.x)
                                   selectionRect.y = Math.min(startPos.y, mouse.y)
                                   selectionRect.width = Math.abs(mouse.x - startPos.x)
                                   selectionRect.height = Math.abs(mouse.y - startPos.y)
                               }
                           }

        onReleased: (mouse)=>{
                        visible=false
                        var s=String(image.source)
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(0,s.indexOf("."))
                        Clipboard.shot(selectionRect.x, selectionRect.y,selectionRect.width, selectionRect.height,s)
                        $load.endShot()
                        selectionRect.visible = false
                    }
    }
    Rectangle{

    }

    // ESC键退出
    Shortcut {
        sequence: "Escape"
        onActivated: $load.endShot()
    }
}
