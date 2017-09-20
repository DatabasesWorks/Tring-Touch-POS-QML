#include "headers/cDocumentItem.h"

cDocumentItem::cDocumentItem(QObject *parent) :
    QObject(parent)
{
}

cDocumentItem::cDocumentItem(qint32 id, qint32 documentId, qint32 typeId,
                             qint32 itemId, QString name, QString barcode, QString unitOfMeasure,
                             qint32 taxId, double taxP,
                             double priceWithTax, double priceWithoutTax,
                             double priceWithDiscount, double discountP, double discount,
                             double input, double output, double currentQuantity,
                             QString customerTitle, QDateTime date)
{
    _id = id;
    _documentId = documentId;
    _typeId = typeId;
    _itemId = itemId;
    _name = name;
    _barcode = barcode;
    _unitOfMeasure = unitOfMeasure;
    _output = output;
    _input = input;
    _taxId = taxId;
    _taxP = taxP;
    _priceWithTax = priceWithTax;
    _priceWithoutTax = priceWithoutTax;
    _discountP = discountP;
    _priceWithDiscount = priceWithDiscount;
    _discountP = discountP;
    _discount = discount;
    _currentQuantity = currentQuantity;
    _customerTitle = customerTitle;
    _date = date;
}

qint32 cDocumentItem::id()
{
    return _id;
}

void cDocumentItem::setId(qint32 id)
{
    _id = id;
}

qint32 cDocumentItem::documentId()
{
    return _documentId;
}

void cDocumentItem::setDocumentId(qint32 receiptId)
{
    _documentId = receiptId;
}

qint32 cDocumentItem::typeId()
{
    return _typeId;
}

void cDocumentItem::setTypeId(qint32 typeId)
{
    _typeId = typeId;
}

qint32 cDocumentItem::itemId()
{
    return _itemId;
}

void cDocumentItem::setItemId(qint32 itemId)
{
    _itemId = itemId;
}

QString cDocumentItem::name()
{
    return _name;
}

void cDocumentItem::setName(QString name)
{
    _name = name;
}

QString cDocumentItem::barcode()
{
    return _barcode;
}

void cDocumentItem::setBarcode(QString barcode)
{
    _barcode = barcode;
}

QString cDocumentItem::unitOfMeasure()
{
    return _unitOfMeasure;
}

void cDocumentItem::setUnitOfMeasure(QString unitOfMeasure)
{
    _unitOfMeasure = unitOfMeasure;
}

qint32 cDocumentItem::taxId()
{
    return _taxId;
}

void cDocumentItem::setTaxId(qint32 taxId)
{
    _taxId = taxId;
}

double cDocumentItem::taxP()
{
    return _taxP;
}

void cDocumentItem::setTaxP(double tax)
{
    _taxP = tax;
}

double cDocumentItem::discountP()
{
    return _discountP;
}

void cDocumentItem::setDiscountP(double discountP)
{
    _discountP = discountP;
}

double cDocumentItem::discount()
{
    return _discount;
}

void cDocumentItem::setDiscount(double discount)
{
    _discount = discount;
}

double cDocumentItem::priceWithTax()
{
    return _priceWithTax;
}

void cDocumentItem::setPriceWithTax(double price)
{
    _priceWithTax = price;
}

double cDocumentItem::priceWithoutTax()
{
    return _priceWithoutTax;
}

void cDocumentItem::setPriceWithoutTax(double priceWithoutTax)
{
    _priceWithoutTax = priceWithoutTax;
}

double cDocumentItem::priceWithDiscount()
{
    return _priceWithDiscount;
}

void cDocumentItem::setPriceWithDiscount(double priceWithDiscount)
{
    _priceWithDiscount = priceWithDiscount;
}

double cDocumentItem::output()
{
    return _output;
}

void cDocumentItem::setOutput(double output)
{
    _output = output;
}

double cDocumentItem::input()
{
    return _input;
}

void cDocumentItem::setInput(double input)
{
    _input = input;
}

double cDocumentItem::currentQuantity()
{
    return _currentQuantity;
}

void cDocumentItem::setCurrentQuantity(double currentQuantity)
{
    _currentQuantity = currentQuantity;
}

QString cDocumentItem::customerTitle()
{
    return _customerTitle;
}

void cDocumentItem::setCustomerTitle(QString customerTitle)
{
    _customerTitle = customerTitle;
}

QDateTime cDocumentItem::date()
{
    return _date;
}

void cDocumentItem::setDate(QDateTime date)
{
    _date = date;
}
