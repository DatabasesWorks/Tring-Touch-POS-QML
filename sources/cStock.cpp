#include "cStock.h"

cStock::cStock(QObject *parent) :
    QObject(parent)
{
    _id = 0;
    _itemId = 0;
    _input = 0;
    _output = 0;
    _sum = 0;
    _documentId = 0;
}

qint32 cStock::id()
{
    return _id;
}

void cStock::setId(qint32 id)
{
    _id = id;
}

qint32 cStock::itemId()
{
    return _itemId;
}

void cStock::setItemId(qint32 itemId)
{
    _itemId = itemId;
}

QString cStock::name()
{
    return _name;
}

void cStock::setName(QString item)
{
    _name = item;
}

QString cStock::unitOfMeasure()
{
    return _unitOfMeasure;
}

void cStock::setUnitOfMeasure(QString unitOfMeasure)
{
    _unitOfMeasure = unitOfMeasure;
}

double cStock::input()
{
    return _input;
}

void cStock::setInput(double input)
{
    _input = input;
}

double cStock::output()
{
    return _output;
}

void cStock::setOutput(double input)
{
    _output = input;
}

double cStock::sum()
{
    return _sum;
}

void cStock::setSum(double sum)
{
    _sum = sum;
}

double cStock::price()
{
    return _price;
}

void cStock::setPrice(double price)
{
    _price = price;
}

qint32 cStock::documentId()
{
    return _documentId;
}

void cStock::setDocumentId(qint32 documentId)
{
    _documentId = documentId;
}

