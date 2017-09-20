#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cDocumentCommon.h"

cDocumentCommon::cDocumentCommon(QObject *parent) :
    QObject(parent)
{

}
cDocument * cDocumentCommon::getNewDocument(qint32 documentTypeId)
{
    cDocument *receipt = new cDocument();
    receipt->setId(0);
    receipt->setTypeId(documentTypeId);
    receipt->setCustomerId(0);
    receipt->setFiscalNumber(0);
    receipt->setCheck(0);
    receipt->setCash(0);
    receipt->setCard(0);
    receipt->setTransferOrder(0);
    receipt->setReclaimedNumber(0);
    receipt->setTotal(0);

    return receipt;
}

qint32 cDocumentCommon::getNewDocumentId()
{
    return cSqlCommon::getNewId("DOCUMENTS", "document_id");
}

bool cDocumentCommon::documentDbInsert(cDocument *document)
{
    //set id
    if (0 == document->id())
    {
        qint32 id = getNewDocumentId();
        document->setId(id);
    }

    QString sQuery("INSERT INTO DOCUMENTS (document_id, document_type_id, title, date, [check], cash, card,"
                   " transfer_order, customer_id, fiscal_number, reclaimed_number,"
                   " note, total, unit_id, created, created_by)"
                   " VALUES (:id, :document_type_id, :title, DATETIME('now'), :check, :cash, :card,"
                   " :transfer_order, :customer_id, :fiscal_number, :reclaimed_number,"
                   " :note, :total, :unit_id, DATETIME('now'), :created_by)");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", document->id());
    query.bindValue(":document_type_id", document->typeId());
    query.bindValue(":title", document->title());
    query.bindValue(":check", document->check());
    query.bindValue(":cash", document->cash());
    query.bindValue(":card", document->card());
    query.bindValue(":transfer_order", document->transferOrder());
    query.bindValue(":customer_id", document->customerId());
    query.bindValue(":fiscal_number", document->fiscalNumber());
    query.bindValue(":reclaimed_number", document->reclaimedNumber());
    query.bindValue(":note", document->note());
    query.bindValue(":total", document->total());
    query.bindValue(":unit_id", cCommon::settings->unit());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (!res)
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cDocumentCommon::documentInsert(cDocument *document, QList<QObject *> documentItems, bool isReclaimReceipt)
{
    bool res = documentDbInsert(document);

    if (res)
    {
        cDocumentItemCommon *documentItemCommon = new cDocumentItemCommon();
        foreach (QObject* o, documentItems)
        {
            cDocumentItem* documentItem = dynamic_cast<cDocumentItem*>(o);
            res = documentItemCommon->documentItemDbInsert(document, documentItem, isReclaimReceipt);
            if (!res) break;
        }
    }

    return res;
}

bool cDocumentCommon::documentDelete(cDocument *document)
{
    bool res = documentDbDelete(document);

    if(res)
    {
        cDocumentItemCommon *documentItemCommon = new cDocumentItemCommon();
        res = documentItemCommon->documentItemDbDelete(document->id());
    }
    return res;
}

bool cDocumentCommon::documentDbDelete(cDocument *document)
{
    QString sQuery("DELETE FROM DOCUMENTS WHERE document_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", document->id());
    query.bindValue(":rid", document->id());

    bool res = query.exec();
    if (!res)
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

