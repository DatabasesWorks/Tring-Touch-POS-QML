#ifndef CSTOCKCOMMON_H
#define CSTOCKCOMMON_H

#include <QObject>

#include "headers/cDocumentItem.h"
#include "headers/cDocument.h"

class cStockCommon : public QObject
{
    Q_OBJECT
public:
    explicit cStockCommon(QObject *parent = 0);
    ~cStockCommon() {}

public slots: 
    QList<QObject*> getStock(QString name);
    QList<QObject*> getItemCard(QString name);

    cDocumentItem *getStockItem(QList<QObject*> list, qint32 index);

    bool insertIntoStock(cDocumentItem *stockItem);

private:
    QList<QObject*> inputOutputList;
    void clearInputOutputList();

    void fillStock();
    void fillItemCard();

    void updateStockList(cDocumentItem *stockItem);
    void setStockItem(cDocument *doc, cDocumentItem *p);
    bool insertStockItem(cDocument *document, cDocumentItem *item);

};

#endif // CSTOCKCOMMON_H
