#ifndef SETTINGSCOMMON_H
#define SETTINGSCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cSettings.h"

class cSettingsCommon : public QObject
{
    Q_OBJECT
public:
    explicit cSettingsCommon(QObject *parent = 0);
    ~cSettingsCommon() {}// qDebug() << "SettingsCommon dying"; }

signals:

public slots:
    void setSettings(cSettings* tSettings);

    QList<QObject *> getPaperWidths();
    qint32 getPaperWidthIndex(qint32 value);

    cSettings* getTempSettings();

private slots:
    bool updateSettings(QString parameter, QString value);

public:
    void fillSettings();

};

#endif // SETTINGSCOMMON_H
