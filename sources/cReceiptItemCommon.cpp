#include "headers/cCommon.h"
#include "headers/conversion.h"
#include "headers/cDocumentItem.h"
#include "headers/cReceiptItemCommon.h"

cReceiptItemCommon::cReceiptItemCommon(QObject *parent) :
    QObject(parent)
{

}

void cReceiptItemCommon::clearReceiptItemList()
{
    receiptItemList.clear();
}

bool cReceiptItemCommon::fillReceiptItemList(qint32 receiptId)
{
    clearReceiptItemList();

    QString sQuery("SELECT DOCUMENT_ITEMS.*, ITEMS.item_id,"
                   " ITEMS.Name as item_name, ITEMS.price, ITEMS.tax_id"
                   " FROM DOCUMENT_ITEMS LEFT OUTER JOIN ITEMS"
                   " ON DOCUMENT_ITEMS.Item_id = ITEMS.item_id"
                   " WHERE document_id = :id AND document_type_id = :type_id"
                   " AND unit_id = :unit_id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", receiptId);
    query.bindValue(":type_id", 24);
    query.bindValue(":unit_id", cCommon::settings->unit());
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
        return false;
    }

    while(query.next())
    {
        cDocumentItem *pap = new cDocumentItem;
        pap->setId(query.value("document_item_id").toInt());
        pap->setTypeId(query.value("document_type_id").toInt());
        pap->setDocumentId(query.value("document_id").toInt());
        pap->setItemId(query.value("item_id").toInt());
        pap->setName(query.value("item_name").toString());
        pap->setOutput(query.value("output").toDouble());
        pap->setTaxId(query.value("tax_id").toInt());
        pap->setTaxP(query.value("tax_%").toDouble());
        pap->setPriceWithTax(query.value("price_with_tax").toDouble());
        pap->setPriceWithDiscount(query.value("price_with_tax_with_discount").toDouble());
        pap->setDiscountP(query.value("discount_%").toDouble());
        pap->setDiscount(query.value("discount").toDouble());

        receiptItemList.append(pap);
    }

    return true;
}

static double getPriceWithoutTax(double priceWithTax, double taxP)
{
    double priceWithoutTax = priceWithTax / (1 + taxP / 100);
    return round_nplaces(priceWithoutTax, 5);
}

static double getDiscount(double priceWithTax, double discountP)
{
    if (discountP < 0)
    {
        discountP *= -1;
    }

    double discount = priceWithTax *  (discountP/100);
    return round_nplaces(discount, 5);
}

static double getPriceWithDiscount(double priceWithTax, double discount)
{
    double priceWithDiscount = priceWithTax - discount;
    return round_nplaces(priceWithDiscount, 5);
}

static void updateItemFromReceiptItemList(cDocumentItem *p, double quantity, double discountP)
{
    p->setOutput(quantity);
    p->setDiscountP(discountP);
    p->setDiscount(getDiscount(p->priceWithTax(), p->discountP()));
    p->setPriceWithDiscount(getPriceWithDiscount(p->priceWithTax(), p->discount()));

    emit p->documentItemChanged();
}

void cReceiptItemCommon::updateReceiptItem(cDocumentItem *ri, double quantity, double discountP)
{
    updateItemFromReceiptItemList(ri, quantity, discountP);
    emit totalCalculated();
}

void cReceiptItemCommon::deleteReceiptItem(cDocumentItem *ri, bool deleteOne)
{
     if (deleteOne && ri->output() > 1)
     {
        ri->setOutput(ri->output() - 1);
     }
     else {
        receiptItemList.removeAll(ri);
     }

     emit ri->documentItemChanged();
     emit totalCalculated();
}

static double getTaxRate(qint32 itemId)
{
    cTaxCommon *taxCommon = new cTaxCommon();
    return taxCommon->getTaxRate(itemId);
}

void cReceiptItemCommon::setReceiptItem(cDocumentItem* p, cItem *item)
{
    p->setDocumentId(0);
    p->setTypeId(24);
    p->setItemId(item->id());
    p->setName(item->name());
    p->setUnitOfMeasure(item->unitOfMeasure());
    p->setInput(0);
    p->setOutput(1);
    p->setTaxId(item->taxId());
    p->setTaxP(getTaxRate(item->id()));
    p->setPriceWithTax(item->price());
    p->setPriceWithoutTax(getPriceWithoutTax(p->priceWithTax(), p->taxP()));

    p->setDiscountP(0);
    p->setDiscount(0);
    p->setPriceWithDiscount(p->priceWithTax());
}

void cReceiptItemCommon::insertItemIntoReceiptList(cDocumentItem* item)
{
    receiptItemList.append(new cDocumentItem(item->id(), item->documentId(), item->typeId(), item->itemId(),
                                             item->name(), item->barcode(), item->unitOfMeasure(),
                                             item->taxId(), item->taxP(),
                                             item->priceWithTax(), item->priceWithoutTax(), item->priceWithDiscount(),
                                             item->discountP(), item->discount(), item->input(), item->output(),
                                             item->currentQuantity(), item->customerTitle(), item->date()));
}

void cReceiptItemCommon::addItemToReceipt(cItem *item)
{
    foreach (QObject* o, receiptItemList)
    {
       cDocumentItem* p = dynamic_cast<cDocumentItem*>(o);
       if (p->itemId() == item->id())
       {
            addReceiptItem(p);
            return;
       }
    }

    /* if not exist in receipt, add it */
    cDocumentItem* p = new cDocumentItem();
    setReceiptItem(p, item);
    insertItemIntoReceiptList(p);
    p->documentItemChanged();
    emit totalCalculated();
}

void cReceiptItemCommon::addReceiptItem(cDocumentItem *ri)
{
    double newQuantity = ri->output() + 1;
    ri->setOutput(newQuantity);
    emit ri->documentItemChanged();
    emit totalCalculated();
}

QList<QObject*> cReceiptItemCommon::getReceiptItemList()
{
    emit totalCalculated();
    return receiptItemList;
}

double cReceiptItemCommon::getTotal()
{
    double total = 0.00;

    foreach (QObject* o, receiptItemList)
    {
        cDocumentItem* item = dynamic_cast<cDocumentItem*>(o);
        total +=  item->priceWithTax() * item->output();

        //For retail first add discount then round the total
        if (item->discountP() > 0)
        {
            total -= (item->discount() * item->output());
        }
        else
        {
            total += (item->discount() * item->output());
        }

    }
    return round_nplaces(total, 2);;
}

QList<QObject *> cReceiptItemCommon::getReceiptItemList(qint32 id)
{
    QList<QObject*> fiscalReceiptItems;

    QString sQuery("SELECT DOCUMENT_ITEMS.*, ITEMS.item_id,"
            " ITEMS.Name as item_name, ITEMS.price, ITEMS.tax_id"
            " FROM DOCUMENT_ITEMS LEFT OUTER JOIN ITEMS "
            " ON DOCUMENT_ITEMS.Item_id = ITEMS.item_id"
            " WHERE document_id = :id AND document_type_id = :type_id"
            " AND unit_id = :unit_id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", id);
    query.bindValue(":type_id", 24);
    query.bindValue(":unit_id", cCommon::settings->unit());
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
        return fiscalReceiptItems;
    }

    while(query.next())
    {
        cDocumentItem *pap = new cDocumentItem;
        pap->setId(query.value("document_item_id").toInt());
        pap->setTypeId(query.value("document_type_id").toInt());
        pap->setDocumentId(query.value("document_id").toInt());
        pap->setItemId(query.value("item_id").toInt());
        pap->setName(query.value("item_name").toString());
        pap->setOutput(query.value("output").toDouble());
        pap->setTaxId(query.value("tax_id").toInt());
        pap->setTaxP(query.value("tax_%").toDouble());
        pap->setPriceWithTax(query.value("price_with_tax").toDouble());
        pap->setPriceWithoutTax(query.value("price_without_tax").toDouble());
        pap->setPriceWithDiscount(query.value("price_with_tax_with_discount").toDouble());
        pap->setDiscountP(query.value("discount_%").toDouble());
        pap->setDiscount(query.value("discount").toDouble());

        fiscalReceiptItems.append(pap);
    }

    return fiscalReceiptItems;
}



