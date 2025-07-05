#include <QObject>
#include <QGuiApplication>
#include <QFileDialog>
#include <QMessageBox>
#include <QClipboard>
#include <QMimeData>
#include <QImage>
#include <QUuid>
#include <QPixmap>
#include <QScreen>
#include <QFile>

class ClipboardHandler : public QObject {
    Q_OBJECT
public:
    explicit ClipboardHandler(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void copyText(const QString &text) {
        QGuiApplication::clipboard()->setText(text);
    }

    Q_INVOKABLE QString pasteText() {
        return QGuiApplication::clipboard()->text();
    }
    Q_INVOKABLE bool hasImage() const
    {
        if (!m_app) return false;
        return m_app->clipboard()->mimeData()->hasImage();
    }

    QImage getImage() const
    {
        if (!hasImage()) return QImage();
        return qvariant_cast<QImage>(m_app->clipboard()->mimeData()->imageData());
    }
    Q_INVOKABLE QString saveImage()
    {
        if (!hasImage()) return "empty";
        QImage image=getImage();
        QString path,name;
        name=QUuid::createUuid().toString(QUuid::Id128).left(8);
        path = "./file/temp/"+name+".png";
        image.save(path,"PNG");
        return "./temp/"+name+".png";
    }
    Q_INVOKABLE void saveAs(const QString &name){
        QString destinationPath = QFileDialog::getSaveFileName(nullptr, "另存为",
                                                               "",
                                                               "PNG 文件 (*.png);;JPEG 文件 (*.jpg *.jpeg);;BMP 文件 (*.bmp)");
        if (destinationPath.isEmpty()) {
            return;
        }

        // 读取并保存图片
        QImage image("./file/temp/"+name+".png");
        if (image.isNull()) {
            QMessageBox::critical(nullptr, "错误", "无法加载图片文件！");
            return;
        }

        if (!image.save(destinationPath)) {
            QMessageBox::critical(nullptr, "错误", "保存图片失败！");
            return;
        }
    }
    Q_INVOKABLE void shot(int x,int y,int w,int h,QString name){
        QImage image("./file/temp/"+name+".png");
        qreal dpr = QGuiApplication::primaryScreen()->devicePixelRatio();
        QRect cropArea(x*dpr, y*dpr,w*dpr,h*dpr);
        // 保存到剪切板
        QGuiApplication::clipboard()->setImage(image.copy(cropArea));

    }
    Q_INVOKABLE QString shot(){
        QScreen *screen = QGuiApplication::primaryScreen();
        QPixmap screenshot = screen->grabWindow();

        // 保存到剪切板
        QGuiApplication::clipboard()->setPixmap(screenshot);
        return saveImage();
    }
private:
    QGuiApplication *m_app;
    int n;
};
