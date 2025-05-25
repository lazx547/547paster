QT += quick \
    widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        clipboardhandler.cpp \
        erwindow.cpp \
        gfile.cpp \
        main.cpp

RESOURCES += \
    1.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    clipboardhandler.h \
    erwindow.h \
    gfile.h

DISTFILES += \
    Cbutton.qml \
    Ccheckbox.qml \
    ColorPicker.qml \
    CscrollBar.qml \
    ImaButton.qml \
    Movetool.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/About.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/CSaveItem.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/Cbutton.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/Ccheckbox.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/ColorPicker.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/ColorPickerItem.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/CscrollBar.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/ImaButton.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/Load.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/PMenuItem.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/Paster.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/ProgreBar.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/SysTray.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/main.qml \
    build/Desktop_Qt_6_8_3_MinGW_64_bit-Debug/file/main_win.qml \
    main.qml

VERSION = 0.9
