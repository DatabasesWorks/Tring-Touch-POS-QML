#include "headers/cDocument.h"

cDocument::cDocument(QObject *parent) :
    QObject(parent)
{
}

cDocument::cDocument(qint32 id, qint32 typeId, QString title, qint32 customerId, QDateTime date,
                     double cash, double check, double card, double transferOrder,
                     qint32 fiscalNumber, qint32 reclaimedNumber,
                     QString note, qint32 total)
{
    _id = id;
    _typeId = typeId;
    _title = title;
    _customerId = customerId;
    _date = date;
    _cash = cash;
    _check = check;
    _card = card;
    _transferOrder = transferOrder;
    _fiscalNumber = fiscalNumber;
    _reclaimedNumber = reclaimedNumber;
    _note = note;
    _total = total;
}

qint32 cDocument::id()
{
    return _id;
}

void cDocument::setId(qint32 id)
{
    _id = id;
}

qint32 cDocument::typeId()
{
    return _typeId;
}

void cDocument::setTypeId(qint32 typeId)
{
    _typeId = typeId;
}

QString cDocument::title()
{
    return _title;
}

void cDocument::setTitle(QString title)
{
    _title = title;
}

qint32 cDocument::customerId()
{
    return _customerId;
}

void cDocument::setCustomerId(qint32 customerId)
{
    _customerId = customerId;
}

QDateTime cDocument::date()
{
    return _date;
}

void cDocument::setDate(QDateTime datum)
{
    _date = datum;
}

double cDocument::cash()
{
    return _cash;
}

void cDocument::setCash(double cash)
{
    _cash = cash;
}

double cDocument::check()
{
    return _check;
}

void cDocument::setCheck(double check)
{
    _check = check;
}

double cDocument::card()
{
    return _card;
}

void cDocument::setCard(double card)
{
    _card = card;
}

double cDocument::transferOrder()
{
    return _transferOrder;
}

void cDocument::setTransferOrder(double transferOrder)
{
    _transferOrder = transferOrder;
}

qint32 cDocument::fiscalNumber()
{
    return _fiscalNumber;
}

void cDocument::setFiscalNumber(qint32 fiscalNumber)
{
    _fiscalNumber = fiscalNumber;
}

qint32 cDocument::reclaimedNumber()
{
    return _reclaimedNumber;
}

void cDocument::setReclaimedNumber(qint32 reclaimedNumber)
{
    _reclaimedNumber = reclaimedNumber;
}

double cDocument::total()
{
    return _total;
}

void cDocument::setTotal(double total)
{
    _total = total;
}

QString cDocument::note()
{
    return _note;
}

void cDocument::setNote(QString note)
{
    _note = note;
}
