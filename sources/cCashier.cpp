#include "headers/cCashier.h"

cCashier::cCashier(QObject *parent) :
    QObject(parent)
{
    _id = 0;
    _roleId = 0;
}

cCashier::cCashier(qint32 id, QString name, QString password, qint32 roleId)
{
    _id = id;
    _name = name;
    _password = password;
    _roleId = roleId;
}

qint32 cCashier::id()
{
    return _id;
}

void cCashier::setId(qint32 id)
{
    _id = id;
}

QString cCashier::name()
{
    return _name;
}

void cCashier::setName(QString name)
{
    _name = name;
}

QString cCashier::password()
{
    return _password;
}

void cCashier::setPassword(QString password)
{
    _password = password;
}

qint32 cCashier::roleId()
{
    return _roleId;
}

void cCashier::setRoleId(qint32 roleId)
{
    _roleId = roleId;
}
