#include "headers/cDocumentItemCommon.h"
#include "headers/cCommon.h"
#include "headers/conversion.h"
#include "headers/cDocumentItem.h"

cDocumentItemCommon::cDocumentItemCommon(QObject *parent) :
    QObject(parent)
{

}

bool cDocumentItemCommon::documentItemDbInsert(cDocument *document, cDocumentItem *item, bool isReceiptReclaim)
{
    QString sQuery("INSERT INTO DOCUMENT_ITEMS (document_id, document_type_id,"
                   " item_id, unit_of_measure,"
                   " input, output,"
                   " tax_id, [tax_%],"
                   " price_with_tax, price_without_tax,"
                   " price_with_tax_with_discount, [discount_%], discount,"
                   " unit_id, created, created_by)"
                   " VALUES (:document_id, :document_type_id,"
                   " :item_id, :unit_of_measure,"
                   " :input, :output,"
                   " :tax_id, :tax_p,"
                   " :price_with_tax, :price_without_tax,"
                   " :price_with_tax_with_discount, :discount_p, :discount,"
                   " :unit_id, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":document_id", document->id());
    query.bindValue(":document_type_id", document->typeId());
    query.bindValue(":item_id", item->itemId());
    query.bindValue(":unit_of_measure", item->unitOfMeasure());
    if (isReceiptReclaim)
    {
        query.bindValue(":input", item->output());
        query.bindValue(":output", item->input());
    }
    else
    {
        query.bindValue(":input", item->input());
        query.bindValue(":output", item->output());
    }
    query.bindValue(":tax_id", item->taxId());
    query.bindValue(":tax_p", item->taxP());
    query.bindValue(":price_with_tax", item->priceWithTax());
    query.bindValue(":price_with_tax_with_discount", item->priceWithDiscount());
    query.bindValue(":price_without_tax", item->priceWithoutTax());
    query.bindValue(":discount_p", item->discountP());
    query.bindValue(":discount", item->discount());
    query.bindValue(":unit_id", cCommon::settings->unit());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (!res)
    {
         qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cDocumentItemCommon::documentItemDbDelete(qint32 documentId)
{
    QString sQuery("DELETE FROM DOCUMENT_ITEMS WHERE document_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", documentId);

    bool res = query.exec();
    if (!res)
    {
         qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
    return res;
}

