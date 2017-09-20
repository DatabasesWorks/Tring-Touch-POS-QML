#include <QObject>
#include <QtSql>

#include "headers/conversion.h"
#include "headers/cCommon.h"
#include "headers/cDocument.h"
#include "headers/cDocumentCommon.h"
#include "headers/cDocumentItem.h"
#include "headers/cStockCommon.h"

cStockCommon::cStockCommon(QObject *parent) :
    QObject(parent)
{

}

static double getPriceWithoutTax(double priceWithTax, double taxP)
{
    double priceWithoutTax = priceWithTax / (1 + taxP / 100);
    return round_nplaces(priceWithoutTax, 5);
}

static double getTaxRate(qint32 itemId)
{
    cTaxCommon *taxCommon = new cTaxCommon();
    return taxCommon->getTaxRate(itemId);
}

void cStockCommon::fillStock()
{
    clearInputOutputList();

    QString sQuery = "SELECT * FROM STOCK_VIEW WHERE unit_id = 0 OR unit_id = :unit_id";
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":unit_id", cCommon::settings->unit());

    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cDocumentItem *stockItem = new cDocumentItem();
        stockItem->setItemId(query.value("item_id").toInt());
        stockItem->setTaxId(query.value("tax_id").toInt());
        stockItem->setName(query.value("name").toString());
        stockItem->setBarcode(query.value("barcode").toString());
        stockItem->setUnitOfMeasure(query.value("unit_of_measure").toString());
        stockItem->setCurrentQuantity(query.value("current_quantity").toDouble());
        stockItem->setInput(query.value("input").toDouble());
        stockItem->setOutput(query.value("output").toDouble());
        stockItem->setPriceWithTax(query.value("price").toDouble());
        stockItem->setTaxP(getTaxRate(stockItem->itemId()));
        stockItem->setPriceWithoutTax(getPriceWithoutTax(stockItem->priceWithTax(), stockItem->taxP()));
        inputOutputList.append(stockItem);
    }
}

void cStockCommon::fillItemCard()
{
    clearInputOutputList();

    QString sQuery = "SELECT * FROM ITEM_CARD_VIEW WHERE unit_id = :unit_id";
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":unit_id", cCommon::settings->unit());
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cDocumentItem *item = new cDocumentItem();
        item->setTypeId(query.value("document_type_id").toInt());
        item->setItemId(query.value("item_id").toInt());
        item->setName(query.value("name").toString());
        item->setBarcode(query.value("barcode").toString());
        item->setUnitOfMeasure(query.value("unit_of_measure").toString());
        item->setInput(query.value("input").toDouble());
        item->setOutput(query.value("output").toDouble());
        item->setPriceWithTax(query.value("price_with_tax").toDouble());
        item->setPriceWithoutTax(query.value("price_without_tax").toDouble());
        item->setDiscountP(query.value("discount_%").toDouble());
        item->setCustomerTitle(query.value("customer_title").toString());
        item->setDate(query.value("date").toDateTime());
        inputOutputList.append(item);
    }
}

void cStockCommon::updateStockList(cDocumentItem *stockItem)
{
    stockItem->setCurrentQuantity(stockItem->currentQuantity() + stockItem->input());
    stockItem->documentItemChanged();
}

void cStockCommon::clearInputOutputList()
{
    inputOutputList.clear();
}

QList<QObject*> cStockCommon::getStock(QString name)
{
    if (name.isEmpty())
    {
        fillStock();
        return inputOutputList;
    }


    QList<QObject*> searchList;

    foreach (QObject* o, inputOutputList)
    {
       cDocumentItem* di = dynamic_cast<cDocumentItem*>(o);
       if (di->name().toUpper().contains(name.toUpper())
               || di->barcode() == name)
       {
           searchList.append(o);
       }
    }

    return searchList;
}

QList<QObject *> cStockCommon::getItemCard(QString name)
{
    if (name.isEmpty())
    {
        fillItemCard();
        return inputOutputList;
    }


    QList<QObject*> searchList;

    foreach (QObject* o, inputOutputList)
    {
       cDocumentItem* di = dynamic_cast<cDocumentItem*>(o);
       if (di->name().toUpper().contains(name.toUpper())
               || di->barcode() == name)
       {
           searchList.append(o);
       }
    }

    return searchList;
}

cDocumentItem *cStockCommon::getStockItem(QList<QObject *> list, qint32 index)
{
    return dynamic_cast<cDocumentItem*>(list.at(index));
}

void cStockCommon::setStockItem(cDocument *doc, cDocumentItem *p)
{
    p->setDocumentId(doc->id());
    p->setTypeId(doc->typeId());

    p->setOutput(0);
    p->setTaxP(getTaxRate(p->itemId()));
    p->setPriceWithoutTax(getPriceWithoutTax(p->priceWithTax(), p->taxP()));

    p->setDiscountP(0);
    p->setDiscount(0);
    p->setPriceWithDiscount(p->priceWithTax());
}

bool cStockCommon::insertIntoStock(cDocumentItem *stockItem)
{
    cDocumentCommon *documentCommon = new cDocumentCommon();
    cDocument *document = documentCommon->getNewDocument(2);

    setStockItem(document, stockItem);

    bool res = insertStockItem(document, stockItem);
    if (res)
    {
        updateStockList(stockItem);
    }

    return res;
}

bool cStockCommon::insertStockItem(cDocument *document, cDocumentItem *item)
{
    QList<QObject*> stockItemList;
    stockItemList.append(item);

    cDocumentCommon *documentCommon = new cDocumentCommon();   
    bool res = documentCommon->documentInsert(document, stockItemList, false);

    return res;
}
