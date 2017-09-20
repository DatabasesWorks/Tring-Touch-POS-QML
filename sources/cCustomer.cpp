#include "headers/cCustomer.h"

cCustomer::cCustomer(QObject *parent)  : QObject(parent)
{
    _id = 0;
}

cCustomer::cCustomer(qint32 id, QString ibk, QString line1, QString line2, QString line3, QString line4)
{
    _id = id;
    _idc = ibk;
    _line1 = line1;
    _line2 = line2;
    _line3 = line3;
    _line4 = line4;
}
qint32 cCustomer::id()
{
   return _id;
}

void cCustomer::setId(qint32 id)
{
   _id = id;
}

QString cCustomer::idc()
{
   return _idc;
}

void cCustomer::setIdc(QString ibk)
{
   _idc = ibk;
}

QString cCustomer::vat_number()
{
   return _vatNumber;
}

void cCustomer::setVatNumber(QString vatNumber)
{
   _vatNumber = vatNumber;
}

QString cCustomer::line1()
{
   return _line1;
}

void cCustomer::setLine1(QString line1)
{
   _line1 = line1;
}

QString cCustomer::line2()
{
   return _line2;
}

void cCustomer::setLine2(QString line2)
{
   _line2 = line2;
}

QString cCustomer::line3()
{
   return _line3;
}

void cCustomer::setLine3(QString line3)
{
   _line3 = line3;
}

QString cCustomer::line4()
{
   return _line4;
}

void cCustomer::setLine4(QString line4)
{
   _line4 = line4;
}

//QDateTime Customer::created()
//{
//    return _created;
//}

//void Customer::setCreated(QDateTime created)
//{
//    _created = created;
//}

//qint32 Customer::createdBy()
//{
//    return _createdBy;
//}

//void Customer::setCreatedBy(qint32 createdBy)
//{
//    _createdBy= createdBy;
//}

//QDateTime Customer::modified()
//{
//    return _modified;
//}

//void Customer::setModified(QDateTime modified)
//{
//    _modified = modified;
//}

//qint32 Customer::modifiedBy()
//{
//    return _modifiedBy;
//}

//void Customer::setModifiedBy(qint32 modifiedBy)
//{
//    _modifiedBy= modifiedBy;
//}






