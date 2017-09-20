#include "headers/cSettings.h"
#include "headers/cPaperWidth.h"
#include "headers/cCommon.h"
#include "headers/bloks/formatter.h"
#include "headers/cSettingsCommon.h"

cSettingsCommon::cSettingsCommon(QObject *parent) :
    QObject(parent)
{

}

QString getPortForPlatform(QString port)
{
#ifdef Q_OS_WIN
    return "\\\\.\\" + port;
#else
    return "/dev/" + port;
#endif
}

void cSettingsCommon::fillSettings()
{
    cCommon::settings = new cSettings();
    QString sQuery("SELECT * FROM SETTINGS");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        if (query.value("parameter").toString() == "paper_width")
            cCommon::settings->setPaperWidth(query.value("value").toInt());
        if (query.value("parameter").toString() == "port")
        {
            cCommon::settings->setPortNo(query.value("value").toString());
            cCommon::settings->setPort(getPortForPlatform(query.value("value").toString()));
        }
        if (query.value("parameter").toString() == "unit")
            cCommon::settings->setUnit(query.value("value").toInt());
        if (query.value("parameter").toString() == "note_cashier")
            cCommon::settings->setNoteCashier(query.value("value").toBool());
        if (query.value("parameter").toString() == "note_predefined")
            cCommon::settings->setNotePredefined(query.value("value").toString());
    }
}

bool cSettingsCommon::updateSettings(QString parameter, QString value)
{
    QString sQuery("UPDATE SETTINGS SET value = :value,"
                   " modified = DATETIME('now'), modified_by = :modified_by"
                   " WHERE parameter = :parameter");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":parameter", parameter);
    query.bindValue(":value", value);
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (!res)
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
    return res;
}

void cSettingsCommon::setSettings(cSettings* tSettings)
{
    if (cCommon::settings->paperWidth() != tSettings->paperWidth())
        if (updateSettings("paper_width", QString::number(tSettings->paperWidth())))
            cCommon::settings->setPaperWidth(tSettings->paperWidth());

    if (cCommon::settings->portNo() != tSettings->portNo())
        if (updateSettings("port", tSettings->portNo()))
        {
          cCommon::settings->setPortNo(tSettings->portNo());
          cCommon::settings->setPort(getPortForPlatform(tSettings->portNo()));
        }

    if (cCommon::settings->unit() != tSettings->unit())
        if (updateSettings("unit", QString::number(tSettings->unit())))
            cCommon::settings->setUnit(tSettings->unit());

    if (cCommon::settings->noteCashier() != tSettings->noteCashier())
        if (updateSettings("note_cashier", QString::number(tSettings->noteCashier())))
            cCommon::settings->setNoteCashier(tSettings->noteCashier());

    if (cCommon::settings->notePredefined() != tSettings->notePredefined())
        if (updateSettings("note_predefined", tSettings->notePredefined()))
            cCommon::settings->setNotePredefined(tSettings->notePredefined());

    emit cCommon::settings->settingsChanged();
}

QList<QObject*> cSettingsCommon::getPaperWidths()
{
    QList<QObject*> dataList;
    //dataList.append(new SirinaPapiraList("58mm", 34));
    dataList.append(new cPaperWidth("58mm [32]", 32));
    dataList.append(new cPaperWidth("80mm [48]", 48));
    return dataList;
}

qint32 cSettingsCommon::getPaperWidthIndex(qint32 value)
{
    QList<QObject*> list = getPaperWidths();

    foreach (QObject* sp, list) {
       if (dynamic_cast<cPaperWidth*>(sp)->value() == value)
           return list.indexOf(sp);
    }
    return -1;
}

cSettings *cSettingsCommon::getTempSettings()
{
    return new cSettings();
}

