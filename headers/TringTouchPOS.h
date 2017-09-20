#ifndef TRINGTOUCHPOS_H
#define TRINGTOUCHPOS_H

#include <QtQml>
#include <QtQuick/QQuickView>
#include <QtCore/QString>
#include <QObject>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QSurfaceFormat>

#include "TringCommon.h"

#ifdef QT_WIDGETS_LIB
#include <QtWidgets/QApplication>
#else
#include <QtGui/QGuiApplication>
#endif

QT_BEGIN_NAMESPACE

#ifdef QT_WIDGETS_LIB
#define Application QApplication
#else
#define Application QGuiApplication
#endif



#define TRINGTOUCHPOS(url) \
    int main(int argc, char *argv[]) \
    { \
        Application app(argc, argv); \
        qmlRegisterType<TringCommon>("TringCommon", 1, 0, "TringCommon");\
        QQmlApplicationEngine engine(QUrl(#url)); \
        QObject *topLevel = engine.rootObjects().value(0); \
        QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);  \
        if ( !window ) { \
            qWarning("Error: Your root item has to be a Window."); \
            return -1; \
        } \
        window->show(); \
        return app.exec(); \
    }

QT_END_NAMESPACE

#endif // TRINGTOUCHPOS_H
