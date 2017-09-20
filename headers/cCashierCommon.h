#ifndef CASHIERCOMMON_H
#define CASHIERCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cCashier.h"

class cCashierCommon : public QObject
{
    Q_OBJECT
public:
    explicit cCashierCommon(QObject *parent = 0);
    ~cCashierCommon() {}// qDebug() << "CashierCommon dying"; }


public slots:
    QList<QObject*> getCashiers(QString name);

    bool checkCashier(QString password);
    void setCashier(cCashier* cashier);

    cCashier *getNewCashier();
    qint32 getNewId();

    bool updateCashier(cCashier* cashier, cCashier* tCashier);
    bool insertCashier(cCashier* cashier);
    bool deleteCashier(cCashier* cashier);

    bool isAdmin(cCashier *cashier);
    bool isPasswordAvailable(QString password, qint32 cashierId);

private:
    QList<QObject*> cashierList;
    void fillCashierList();
    void insertItemIntoList(cCashier* cashier);

};

#endif // CASHIERCOMMON_H
