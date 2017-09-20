# Add more folders to ship with the application, here
folder_01.source = android/assets
folder_01.target = qml
folder_02.source = qml/TringTouchPOS

DEPLOYMENTFOLDERS = folder_01 folder_02
QT += qml quick sql gui #androidextras

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

VERSION_MAJOR = 1
VERSION_MINOR = 1
VERSION_BUILD = 0

DEFINES += "VERSION_MAJOR=$$VERSION_MAJOR"\
        "VERSION_MINOR=$$VERSION_MINOR" \
        "VERSION_BUILD=$$VERSION_BUILD"

#Target version
VERSION = $${VERSION_MAJOR}.$${VERSION_MINOR}.$${VERSION_BUILD}
DEFINES += VERSION_STRING=\\\"$$VERSION\\\"

GIT_VERSION = $$system(git --git-dir D:/PROJEKTI/Tring.POS/.git --work-tree $$PWD describe --dirty)
DEFINES += GIT_VERSION=\\\"$$GIT_VERSION\\\"

DEFINES += GIT_CURRENT_SHA1="\\\"$(shell git -C \""$$_PRO_FILE_PWD_"\" describe --dirty)\\\""

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += sources/main.cpp \
    sources/cCashier.cpp \
    sources/cCashierCommon.cpp \
    sources/cCommon.cpp \
    sources/cCustomer.cpp \
    sources/cCustomerCommon.cpp \
    sources/cGroup.cpp \
    sources/cItem.cpp \
    sources/cItemCommon.cpp \
    sources/cPaperWidth.cpp \
    sources/cSettings.cpp \
    sources/cSettingsCommon.cpp \
    sources/cSubgroup.cpp \
    sources/cSubgroupCommon.cpp \
    sources/cTax.cpp \
    sources/cTaxCommon.cpp \
    sources/cConnection.cpp \
    sources/cSqlCommon.cpp \
    sources/cStockCommon.cpp \
    sources/codePage.cpp \
    sources/conversion.cpp \
    sources/report.cpp \
    sources/wrapper.cpp \
    sources/bloks/formatter.cpp \
    sources/bloks/separator.cpp \
    sources/screen.cpp \
    sources/keyemitter.cpp \
    sources/cDocument.cpp \
    sources/cDocumentCommon.cpp \
    sources/cDocumentItem.cpp \
    sources/cDocumentItemCommon.cpp \
    sources/cReceiptCommon.cpp \
    sources/cReceiptItemCommon.cpp \
    sources/cGroupCommon.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
#include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
#qtcAddDeployment()

RESOURCES += \
    Resources.qrc \
    translations.qrc

HEADERS += \
    headers/cCashier.h \
    headers/cCashierCommon.h \
    headers/cCommon.h \
    headers/cCustomer.h \
    headers/cCustomerCommon.h \
    headers/cGroup.h \
    headers/cGroupCommon.h \
    headers/cItemCommon.h \
    headers/cItem.h \
    headers/cPaperWidth.h \
    headers/cSettings.h \
    headers/cSettingsCommon.h \
    headers/cSubgroup.h \
    headers/cSubgroupCommon.h \
    headers/cTax.h \
    headers/cTaxCommon.h \
    headers/cConnection.h \
    headers/cSqlCommon.h \
    headers/cStockCommon.h \
    headers/codePage.h \
    headers/conversion.h \
    headers/report.h \
    headers/wrapper.h \
    headers/bloks/formatter.h \
    headers/bloks/separator.h \
    headers/screen.h \
    headers/keyemitter.h \
    headers/cDocument.h \
    headers/cDocumentCommon.h \
    headers/cDocumentItemCommon.h \
    headers/cDocumentItem.h \
    headers/cReceiptCommon.h \
    headers/cReceiptItemCommon.h

lupdate_only {
    SOURCES += *.qml \
            content/*.qml \
            controls/*.qml
}

TRANSLATIONS +=  TringTouchPOS_en.ts

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

win32: LIBS += -L$$PWD/libs/win/ -lTringFiscalLibrary
unix:!macx: LIBS += -L$$PWD/libs/android/ -lTringFiscalLibrary

INCLUDEPATH += $$PWD/libs
DEPENDPATH += $$PWD/libs
