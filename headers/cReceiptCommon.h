#ifndef CRECEIPTCOMMON_H
#define CRECEIPTCOMMON_H

#include <QObject>
#include <QtSql>

#include <headers/cCustomer.h>
#include "headers/cDocument.h"

class cReceiptCommon : public QObject
{
    Q_OBJECT
public:
    explicit cReceiptCommon(QObject *parent = 0);
    ~cReceiptCommon() {}

public slots:
    QList<QObject*> getNonfiscalReceipts();
    QList<QObject*> searchNonfiscalReceipts(QString searchTerm);

    cDocument * getNewReceipt();
    qint32 getNewReceiptId();
    qint32 getFiscalReceiptId(qint32 fiscalNumber);


    qint32 receiptPrint(cDocument *receipt, QList<QObject *> receiptItems,
                        cReceiptCommon *receiptCommon, bool isNew, bool isReclaim);
    qint32 receiptSave(cDocument *receipt, QList<QObject *> receiptItems,
                       cReceiptCommon *receiptCommon);
    qint32 receiptNumberSave(cDocument *receipt, cReceiptCommon *receiptCommon);
    qint32 receiptDelete(cDocument *receipt, cReceiptCommon *receiptCommon);

private:
    QList<QObject*> nonfiscalReceiptList;
    void fillNonfiscalReceiptList();
    void insertItemIntoList(cDocument* item);

    bool receiptDbInsert(cDocument *receipt, QList<QObject*> receiptItems,
                         bool addToList, bool isReclaim);
    bool receiptDbUpdate(cDocument *receipt);
    bool receiptDbDelete(cDocument *receipt);
};

#endif // CRECEIPTCOMMON_H
