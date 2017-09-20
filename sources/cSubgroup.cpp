#include "headers/cSubgroup.h"

cSubgroup::cSubgroup(QObject *parent) :
    QObject(parent)
{
    _id = 0;
    _groupId = 0;
}

cSubgroup::cSubgroup(qint32 id, QString name, qint32 groupId)
{
    _id = id;
    _name = name;
    _groupId = groupId;
}

qint32 cSubgroup::id()
{
    return _id;
}

void cSubgroup::setId(qint32 id)
{
    _id = id;
}

qint32 cSubgroup::groupId()
{
    return _groupId;
}

void cSubgroup::setGroupId(qint32 groupId)
{
    _groupId = groupId;
}

QString cSubgroup::name()
{
    return _name;
}

void cSubgroup::setName(QString name)
{
    _name = name;
}
