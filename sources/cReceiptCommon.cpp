#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cReceiptItemCommon.h"
#include "headers/cReceiptCommon.h"

cReceiptCommon::cReceiptCommon(QObject *parent) :
    QObject(parent)
{
    //fillNonfiscalReceiptList();
}

bool compareReceiptById(QObject* a, QObject* b)
{
    return (dynamic_cast<cDocument*>(a))->id() > (dynamic_cast<cDocument*>(b))->id();
}

void cReceiptCommon::fillNonfiscalReceiptList()
{
    QString sQuery("SELECT * FROM DOCUMENTS WHERE fiscal_number = 0 and document_type_id = 24");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cDocument *receipt = new cDocument;
        receipt->setId(query.value("document_id").toInt());
        receipt->setTypeId(query.value("document_type_id").toInt());
        receipt->setTitle(query.value("title").toString());
        receipt->setCustomerId(query.value("customer_id").toInt());
        receipt->setDate(query.value("date").toDateTime());
        receipt->setCash(query.value("cash").toDouble());
        receipt->setCheck(query.value("check").toDouble());
        receipt->setCard(query.value("card").toDouble());
        receipt->setTransferOrder(query.value("transfer_order").toDouble());
        receipt->setFiscalNumber(query.value("fiscal_number").toInt());
        receipt->setReclaimedNumber(query.value("reclaimed_number").toInt());
        receipt->setNote(query.value("note").toString());
        receipt->setTotal(query.value("total").toInt());
        nonfiscalReceiptList.append(receipt);
    }

    qSort(nonfiscalReceiptList.begin(), nonfiscalReceiptList.end(), compareReceiptById);
}

void cReceiptCommon::insertItemIntoList(cDocument *item)
{
    nonfiscalReceiptList.insert(0, new cDocument(item->id(), item->typeId(), item->title(), item->customerId(), item->date(), item->cash(), item->check(),
                                    item->card(), item->transferOrder(), item->fiscalNumber(), item->reclaimedNumber(),
                                    item->note(), item->total()));
}

QList<QObject*> cReceiptCommon::getNonfiscalReceipts()
{
    nonfiscalReceiptList.clear();
    fillNonfiscalReceiptList();

    return nonfiscalReceiptList;
}

QList<QObject *> cReceiptCommon::searchNonfiscalReceipts(QString searchTerm)
{
    if (searchTerm.isEmpty())
    {
        return nonfiscalReceiptList;
    }

    QList<QObject*> searchList;

    foreach (QObject* o, nonfiscalReceiptList)
    {
       cDocument* p = dynamic_cast<cDocument*>(o);
       if (p->title().toUpper().contains(searchTerm.toUpper()))
       {
           searchList.append(o);
       }
    }

    return searchList;
}

cDocument * cReceiptCommon::getNewReceipt()
{
    cDocumentCommon *documentCommon = new cDocumentCommon();
    return documentCommon->getNewDocument(24);
}

qint32 cReceiptCommon::getNewReceiptId()
{
    cDocumentCommon *documentCommon = new cDocumentCommon();
    return documentCommon->getNewDocumentId();
}

bool cReceiptCommon::receiptDbInsert(cDocument *receipt, QList<QObject*> receiptItems,
                                      bool addToList, bool isReclaim)
{
    //set id
    if (0 == receipt->id())
    {
        cDocumentCommon *documentCommon = new cDocumentCommon();
        qint32 id = documentCommon->getNewDocumentId();
        receipt->setId(id);
    }

    cDocumentCommon *documentCommon = new cDocumentCommon();
    bool res = documentCommon->documentInsert(receipt, receiptItems, isReclaim);

    if (res && addToList)
        insertItemIntoList(receipt);

    return res;
}

bool cReceiptCommon::receiptDbUpdate(cDocument *receipt)
{
    QString sQuery("UPDATE DOCUMENTS SET date = :date, [check] = :check, cash = :cash, card = :card,"
                   " transfer_order = :transfer_order, customer_id = :customer_id, "
                   " fiscal_number = :fiscal_number, reclaimed_number = :reclaimed_number,"
                   " note = :note, total = :total, unit_id = :unit_id,"
                   " modified = DATETIME('now'), modified_by = :created_by"
                   " WHERE document_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", receipt->id());
    query.bindValue(":date", receipt->date());
    query.bindValue(":check", receipt->check());
    query.bindValue(":cash", receipt->cash());
    query.bindValue(":card", receipt->card());
    query.bindValue(":transfer_order", receipt->transferOrder());
    query.bindValue(":customer_id", receipt->customerId());
    query.bindValue(":fiscal_number", receipt->fiscalNumber());
    query.bindValue(":reclaimed_number", receipt->reclaimedNumber());
    query.bindValue(":note", receipt->note());
    query.bindValue(":total", receipt->total());
    query.bindValue(":unit_id", cCommon::settings->unit());
    query.bindValue(":modified_by", cCommon::cashier->id());

    if (query.exec())
    {
        nonfiscalReceiptList.removeOne(receipt);
        return true;
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return false;
}

bool cReceiptCommon::receiptDbDelete(cDocument *receipt)
{
    cDocumentCommon *documentCommon = new cDocumentCommon();
    bool res = documentCommon->documentDelete(receipt);

    if (res)
    {
        nonfiscalReceiptList.removeOne(receipt);
    }

    return res;
}

qint32 cReceiptCommon::getFiscalReceiptId(qint32 fiscalNumber)
{
    qint32 id = -1;

    QString sQuery("SELECT document_id FROM DOCUMENTS "
                   "WHERE fiscal_number = :number AND document_type_id = :type_id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":number", fiscalNumber);
    query.bindValue(":type_id", 24);

    if (query.exec())
    {
       if (query.first())
       {
            id = query.value(0).toInt();
            query.finish();
       }
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return id;
}

qint32 cReceiptCommon::receiptPrint(cDocument *receipt, QList<QObject *> receiptItems,
                                     cReceiptCommon *receiptCommon, bool isNew, bool isReclaim)
{
    cCommon *common = new cCommon();
    int res = -1;

    if(isReclaim)
        res = common->tflReclaimReceipt(receipt, receiptItems);
    else
        res = common->tflReceipt(receipt, receiptItems);

    if (0 == res)
    {
        bool isOK = false;

        if (isNew)
            isOK = receiptCommon->receiptDbInsert(receipt, receiptItems, false, isReclaim);
        else
            isOK = receiptCommon->receiptDbUpdate(receipt);

        if (!isOK)
        {
            return -1;
        }
    }

    return res;
}

qint32 cReceiptCommon::receiptSave(cDocument *receipt, QList<QObject *> receiptItems,
                                    cReceiptCommon *receiptCommon)
{
    if (receiptCommon->receiptDbInsert(receipt, receiptItems, true, false))
    {
        return 0;
    }

    return -1;
}

qint32 cReceiptCommon::receiptNumberSave(cDocument *receipt, cReceiptCommon *receiptCommon)
{
    if (receiptCommon->receiptDbUpdate(receipt))
    {
        return 0;
    }

    return -1;
}

qint32 cReceiptCommon::receiptDelete(cDocument *receipt, cReceiptCommon *receiptCommon)
{
    if (receiptCommon->receiptDbDelete(receipt))
    {
        return 0;
    }

    return -1;
}
