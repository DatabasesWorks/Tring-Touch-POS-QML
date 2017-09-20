#ifndef CSQLCOMMON_H
#define CSQLCOMMON_H

#include <QObject>
#include <QString>

class cSqlCommon : public QObject
{
    Q_OBJECT
public:
    explicit cSqlCommon(QObject *parent = 0);

    static qint32 getNewId(QString tableName, QString idName);

signals:

public slots:
};

#endif // CSQLCOMMON_H
