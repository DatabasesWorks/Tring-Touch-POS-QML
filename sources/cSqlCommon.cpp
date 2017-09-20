#include <QtSql>

#include "headers/cSqlCommon.h"

cSqlCommon::cSqlCommon(QObject *parent) : QObject(parent)
{

}

qint32 cSqlCommon::getNewId(QString tableName, QString idName)
{
    qint32 id = 0;

    QString sQuery("SELECT IFNULL(MAX(" + idName + "), 0) + 1 as ID FROM " + tableName);
    QSqlQuery query;
    query.prepare(sQuery);

    if (query.exec())
    {
       if (query.first())
       {
            id = query.value(0).toInt();
            query.finish();
       }
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return id;
}
