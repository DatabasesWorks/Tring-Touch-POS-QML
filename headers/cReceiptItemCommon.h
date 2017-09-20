#ifndef CRECEIPTITEMCOMMON_H
#define CRECEIPTITEMCOMMON_H

#include "headers/cDocumentItem.h"
#include "headers/cItem.h"

class cReceiptItemCommon : public QObject
{
    Q_OBJECT
public:
    explicit cReceiptItemCommon(QObject *parent = 0);
    ~cReceiptItemCommon() {}

public slots:
     QList<QObject *> getReceiptItemList();
     QList<QObject *> getReceiptItemList(qint32 id);

     double getTotal();

     void addItemToReceipt(cItem* item);
     void addReceiptItem(cDocumentItem *ri);
     void updateReceiptItem(cDocumentItem *ri, double quantity, double discountP);
     void deleteReceiptItem(cDocumentItem* ri, bool deleteOne);

     void setReceiptItem(cDocumentItem *p, cItem *item);
     void clearReceiptItemList();

     bool fillReceiptItemList(qint32 receiptId);

signals:
      void totalCalculated();

private:
     QList<QObject*> receiptItemList;
     void insertItemIntoReceiptList(cDocumentItem* item);
};

#endif // CRECEIPTITEMCOMMON_H
