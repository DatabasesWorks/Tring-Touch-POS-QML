#ifndef CCONNECTION_H
#define CCONNECTION_H

#include <QObject>
#include <QtSql>

class cConnection : public QObject
{
    Q_OBJECT

public:
    cConnection();
    ~cConnection();

    bool setConnection();

    QString dbName();
    void setDbName(QString dbName);

public slots:
    QString getDatabaseName();
    bool copyDatabaseFromResource();
    QString getDatabasePath();
    QString getDatabaseFullPath();

private:
    QSqlDatabase DB;
};

#endif // CCONNECTION_H
