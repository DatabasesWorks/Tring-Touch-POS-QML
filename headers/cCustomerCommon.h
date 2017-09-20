#ifndef CUSTOMERCOMMON_H
#define CUSTOMERCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cCustomer.h"

class cCustomerCommon: public QObject
{
    Q_OBJECT
public:
    explicit cCustomerCommon(QObject *parent = 0);
    ~cCustomerCommon() {}// qDebug() << "CustomerCommon dying"; }

public slots:
    QList<QObject *> getCustomers(QString name);

    bool updateCustomer(cCustomer* customer, cCustomer* tCustomer);
    bool insertCustomer(cCustomer* customer);
    bool deleteCustomer(cCustomer* customer);

    cCustomer *getNewCustomer();
    qint32 getNewId();

    qint32 getCustomerIndex(qint32 id);
    cCustomer *getCustomer(qint32 id);
    QString customerGetLine1(qint32 id);

private:
    QList<QObject*> customerList;
    void fillCustomerList();
    void insertItemIntoList(cCustomer* customer);

};

#endif // CUSTOMERCOMMON_H
