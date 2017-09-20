#include <QObject>
#include <QString>

#include "headers/cItem.h"

cItem::cItem(QObject *parent)  : QObject(parent)
{
    _id = 0;
    _groupId = 0;
    _subgroupId = 0;
    _price = 0;
    _taxId = 0;
    _top = 0;
}

cItem::cItem(qint32 id, QString barcode, QString name, QString unitOfMeasure,
             qint32 groupId, qint32 subgroupId,
             double price, qint32 taxId, bool top)
{
    _id = id;
    _barcode = barcode;
    _name = name;
    _unitOfMeasure = unitOfMeasure;
    _groupId = groupId;
    _subgroupId = subgroupId;
    _price = price;
    _taxId = taxId;
    _top = top;
}

qint32 cItem::id() const
{
    return _id;
}

void cItem::setId(const qint32 id)
{
    _id = id;
}

QString cItem::barcode() const
{
    return _barcode;
}

void cItem::setBarcode(const QString barcode)
{
    _barcode = barcode;
}

QString cItem::name() const
{
    return _name;
}

void cItem::setName(const QString name)
{
    _name = name;
}

QString cItem::unitOfMeasure() const
{
    return _unitOfMeasure;
}

void cItem::setUnitOfMeasure(const QString unitOfMeasure)
{
    _unitOfMeasure = unitOfMeasure;
}

qint32 cItem::groupId() const
{
    return _groupId;
}

void cItem::setGroupId(const qint32 groupId)
{
    _groupId = groupId;
}

qint32 cItem::subgroupId() const
{
    return _subgroupId;
}

void cItem::setSubgroupId(const qint32 subgroupId)
{
    _subgroupId = subgroupId;
}

double cItem::price() const
{
    return _price;
}

void cItem::setPrice(const double price)
{
    _price = price;
}

qint32 cItem::taxId() const
{
    return _taxId;
}

void cItem::setTaxId(const qint32 taxId)
{
    _taxId = taxId;
}

bool cItem::top() const
{
    return _top;
}

void cItem::setTop(const bool top)
{
    _top = top;
}
