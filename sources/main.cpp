#include <QtQml>
#include <QtQuick/QQuickView>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QScreen>

#include "headers/cConnection.h"
#include "headers/cStockCommon.h"
#include "headers/cCommon.h"
#include "headers/screen.h"
#include "headers/keyemitter.h"
#include "headers/cReceiptCommon.h"
#include "headers/cReceiptItemCommon.h"

#ifdef QT_WIDGETS_LIB
#include <QtWidgets/QApplication>
#else
#include <QtGui/QGuiApplication>
#endif

#ifdef QT_WIDGETS_LIB
#define Application QApplication
#else
#define Application QGuiApplication
#endif

int main(int argc, char *argv[])
{
    Application app(argc, argv);

    qmlRegisterType<cItem>("TItem", 1, 0, "TItem");
    qmlRegisterType<cCustomer>("TCustomer", 1, 0, "TCustomer");
    qmlRegisterType<cGroup>("TGroup", 1, 0, "TGroup");
    qmlRegisterType<cSubgroup>("TSubgroup", 1, 0, "TSubgroup");
    qmlRegisterType<cTax>("TTax", 1, 0, "TTax");
    qmlRegisterType<cDocument>("TDocument", 1, 0, "TDocument");
    qmlRegisterType<cDocumentItem>("TDocumentItem", 1, 0, "TDocumentItem");
    qmlRegisterType<cReceiptItemCommon>("TReceiptItemCommon", 1, 0, "TReceiptItemCommon");
    qmlRegisterType<cSettings>("TSettings", 1, 0, "TSettings");
    qmlRegisterType<cCashier>("TCashier", 1, 0, "TCashier");

    QTranslator qtTranslator;
    qtTranslator.load("TringTouchPOS_" + QLocale::system().name(), ":/translations/");
    app.installTranslator(&qtTranslator);

    QScreen* screen = QGuiApplication::primaryScreen();
    screen->setOrientationUpdateMask(Qt::LandscapeOrientation
                                     | Qt::PortraitOrientation
                                     | Qt::InvertedLandscapeOrientation
                                     | Qt::InvertedPortraitOrientation);

    //set db connection
    cConnection connection;
    if (!connection.setConnection())
    {
        qWarning("Error: Connection failed.");
        return -1;
    }

    //load settings
    cSettingsCommon *settingsCommon = new cSettingsCommon();
    settingsCommon->fillSettings();

    //initialize cashier
    cCommon::cashier = new cCashier();

    //create and fill
    cCommon *common = new cCommon();
    cCashierCommon *cashierCommon = new cCashierCommon();

    cItemCommon *itemCommon = new cItemCommon();
    cGroupCommon *groupCommon = new cGroupCommon();
    cSubgroupCommon *subgroupCommon = new cSubgroupCommon();
    cTaxCommon *taxCommon = new cTaxCommon();
    cCustomerCommon *customerCommon = new cCustomerCommon();
    cStockCommon *stockCommon = new cStockCommon();

    cReceiptCommon *receiptCommon = new cReceiptCommon();
    KeyEmitter keyEmitter;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("mSettings", cCommon::settings);
    engine.rootContext()->setContextProperty("mCashier", cCommon::cashier);
    engine.rootContext()->setContextProperty("common", common);
    engine.rootContext()->setContextProperty("itemCommon", itemCommon);
    engine.rootContext()->setContextProperty("customerCommon", customerCommon);
    engine.rootContext()->setContextProperty("groupCommon", groupCommon);
    engine.rootContext()->setContextProperty("subgroupCommon", subgroupCommon);
    engine.rootContext()->setContextProperty("taxCommon", taxCommon);
    engine.rootContext()->setContextProperty("receiptCommon", receiptCommon);
    engine.rootContext()->setContextProperty("cashierCommon", cashierCommon);
    engine.rootContext()->setContextProperty("settingsCommon", settingsCommon);
    engine.rootContext()->setContextProperty("stockCommon", stockCommon);
    engine.rootContext()->setContextProperty("keyEmitter", &keyEmitter);
    engine.load(QUrl("qrc:/QMain.qml"));

    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window)
    {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }
    window->setMinimumHeight(screen->size().height());
    window->setMinimumWidth(screen->size().width());
    window->showMaximized();


//    if (!screen_size_in_range(screen))
//    {
//        qWarning("Error: Invalid screen resolution.");
//        return -1;
//    }

//   screen_window_show(window, screen);
    return app.exec();
}
