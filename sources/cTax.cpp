#include "headers/cTax.h"

cTax::cTax(QObject *parent) :
    QObject(parent)
{
    _id = 0;
    _taxRate = -1;
}

cTax::cTax(qint32 id, QString name, double taxRate, QString code)
{
    _id = id;
    _name = name;
    _taxRate = taxRate;
    _code = code;
}

qint32 cTax::id()
{
    return _id;
}

void cTax::setId(qint32 id)
{
    _id = id;
}

QString cTax::name()
{
    return _name;
}

void cTax::setName(QString name)
{
    _name = name;
}

double cTax::taxRate()
{
    return _taxRate;
}

void cTax::setTaxRate(double taxRate)
{
    _taxRate = taxRate;
}

QString cTax::code()
{
    return _code;
}

void cTax::setCode(QString code)
{
    _code = code;
}

