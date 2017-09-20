#include "headers/cGroup.h"

cGroup::cGroup(QObject *parent) :
    QObject(parent)
{
    _id = 0;
}

cGroup::cGroup(qint32 id, QString name)
{
    _id = id;
    _name = name;
}

qint32 cGroup::id()
{
    return _id;
}

void cGroup::setId(qint32 id)
{
    _id = id;
}

QString cGroup::name()
{
    return _name;
}

void cGroup::setName(QString name)
{
    _name = name;
}
