#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cCashierCommon.h"

cCashierCommon::cCashierCommon(QObject *parent) :
    QObject(parent)
{
    fillCashierList();
}

bool compareCashierByName(QObject* cashierA, QObject* cashierB)
{
    return (dynamic_cast<cCashier*>(cashierA))->name() > (dynamic_cast<cCashier*>(cashierB))->name();
}

void cCashierCommon::fillCashierList()
{
    QString sQuery = "SELECT * FROM CASHIERS ORDER BY name DESC";
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cCashier *cashier = new cCashier;
        cashier->setId(query.value("cashier_id").toInt());
        cashier->setName(query.value("name").toString());
        cashier->setPassword(query.value("password").toString());
        cashier->setRoleId(query.value("role_id").toInt());
        cashierList.append(cashier);
    }
}

void cCashierCommon::insertItemIntoList(cCashier *cashier)
{
    cashierList.append(new cCashier(cashier->id(), cashier->name(), cashier->password(), cashier->roleId()));
    qSort(cashierList.begin(), cashierList.end(), compareCashierByName);
}

QList<QObject*> cCashierCommon::getCashiers(QString name)
{
    if (name.isEmpty())
    {
        return cashierList;
    }

    QList<QObject*> searchList;

    foreach (QObject* o, cashierList)
    {
       cCashier* p = dynamic_cast<cCashier*>(o);
       if (p->name().toUpper().contains(name.toUpper()))
       {
           searchList.append(o);
       }
    }

    return searchList;
}

void cCashierCommon::setCashier(cCashier* cashier)
{
    cCommon::cashier->setId(cashier->id());
    cCommon::cashier->setName(cashier->name());
    cCommon::cashier->setPassword(cashier->password());
    cCommon::cashier->setRoleId(cashier->roleId());
    cCommon::cashier->cashierChanged();
}

cCashier *cCashierCommon::getNewCashier()
{
    return new cCashier();
}

qint32 cCashierCommon::getNewId()
{
    return cSqlCommon::getNewId("CASHIERS", "cashier_id");
}

void updateItemFromCashierList(cCashier* cashier, cCashier *tCashier)
{
    cashier->setId(tCashier->id());
    cashier->setName(tCashier->name());
    cashier->setPassword(tCashier->password());
    cashier->setRoleId(tCashier->roleId());
}

bool cCashierCommon::updateCashier(cCashier *cashier, cCashier *tCashier)
{
    QString sQuery("UPDATE CASHIERS SET cashier_id = :nid, name = :name,"
                    " password = :password, role_id = :role_id,"
                    " modified = DATETIME('now'), modified_by = :modified_by"
                    " WHERE cashier_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tCashier->id());
    query.bindValue(":name", tCashier->name());
    query.bindValue(":password", tCashier->password());
    query.bindValue(":role_id", tCashier->roleId());
    query.bindValue(":id", cashier->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (query.exec())
    {
        updateItemFromCashierList(cashier, tCashier);
        qSort(cashierList.begin(), cashierList.end(), compareCashierByName);
        emit cashier->cashierChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}


bool cCashierCommon::insertCashier(cCashier *cashier)
{
    QString sQuery("INSERT INTO CASHIERS (cashier_id, name, password, role_id, created, created_by)"
                    " VALUES (:id, :name, :password, :roleid, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", cashier->id());
    query.bindValue(":name", cashier->name());
    query.bindValue(":password", cashier->password());
    query.bindValue(":roleId", cashier->roleId());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(cashier);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cCashierCommon::deleteCashier(cCashier *cashier)
{
    QString sQuery("DELETE FROM CASHIERS WHERE cashier_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", cashier->id());

    bool res = query.exec();
    if (res)
    {
        cashierList.removeOne(cashier);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cCashierCommon::isAdmin(cCashier *cashier)
{
    return (cashier->id() == 1);
}

bool cCashierCommon::isPasswordAvailable(QString password, qint32 cashierId)
{
    foreach (QObject* o, cashierList)
    {
       cCashier* c = dynamic_cast<cCashier*>(o);
       if (c->password() == password)
       {
           if (c->id() == cashierId)
           {
               return true;
           }
           return false;
       }
    }

    return true;
}

bool cCashierCommon::checkCashier(QString password)
{
    if (password.isEmpty())
    {
        return false;
    }

    foreach (QObject* o, cashierList)
    {
       cCashier* c = dynamic_cast<cCashier*>(o);
       if (c->password() == password)
       {
           setCashier(c);
           return true;
       }
    }

    return false;
}

