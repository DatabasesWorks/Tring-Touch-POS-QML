#include "headers/cConnection.h"

cConnection::cConnection()
{

}

cConnection::~cConnection()
{
    DB.close();
}

bool cConnection::setConnection()
{
    if (!copyDatabaseFromResource())
    {
        return false;
    }

    QString databasePath = getDatabaseFullPath();
    DB = QSqlDatabase::addDatabase("QSQLITE");
    DB.setDatabaseName(databasePath);
    QFileInfo checkfile(databasePath);

    if (checkfile.isFile())
    {
        if (DB.open())
        {
            return true;
        }
        else
        {
            qDebug() << "Database opening failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "Database file error!";
        return false;
    }
}

QString cConnection::getDatabaseName()
{
    return "TringTouchPOS.sqlite";
}

bool cConnection::copyDatabaseFromResource()
{
    QString absoluteDatabaseFilePath = getDatabaseFullPath();
    qDebug()<<"Database path: "<< absoluteDatabaseFilePath;
    QFileInfo databaseFileInfo(absoluteDatabaseFilePath);

    bool res = true;
    if (!databaseFileInfo.exists())
    {
        res = QFile::copy(":/db/TringTouchPOS.sqlite", absoluteDatabaseFilePath);
        if (!res)
        {
            qDebug() << "Database copying failed!";
            return res;
        }
    }

    res = QFile::setPermissions(absoluteDatabaseFilePath, QFile::ReadOwner | QFile::WriteOwner);
    if (!res)
    {
        qDebug() << "Database permission failed!";
    }

    return res;
}

QString cConnection::getDatabasePath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
//    return QDir::currentPath();
}

QString cConnection::getDatabaseFullPath()
{
    return QString("%1/%2").arg(getDatabasePath()).arg(getDatabaseName());
}
