import QtQuick
import Qt.labs.platform 1.1
import QtQuick.Controls
import Clipboard 1.0
Window{
    x:-100
    y:-100
    width: 0
    height:0
    SystemTrayIcon {//托盘图标
        id:root
        visible: true
        icon.source: "qrc:/images/sys_Tray.png"
        onActivated:(reason)=>{
                        if (reason === SystemTrayIcon.Context) {
                            menu.open()
                        } else {
                            $load.create()
                        }
                    }
        menu:Menu{
            id:menu
            MenuItem{
                text: "截图(保存到剪切板)"
                onTriggered: $load.shot()
            }
            MenuItem{
                text: "退出"
                onTriggered: Qt.quit()
            }
        }
        Component.onCompleted: $menu=menu
    }
}

