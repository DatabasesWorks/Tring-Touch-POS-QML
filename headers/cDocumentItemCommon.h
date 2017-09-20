#ifndef DOCUMENTITEMCOMMON_H
#define DOCUMENTITEMCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cDocumentItem.h"
#include "headers/cDocument.h"

class cDocumentItemCommon : public QObject
{
    Q_OBJECT
public:
    explicit cDocumentItemCommon(QObject *parent = 0);
    ~cDocumentItemCommon() {}
public slots:
    bool documentItemDbInsert(cDocument *document, cDocumentItem *item, bool isReceiptReclaim);
    bool documentItemDbDelete(qint32 documentId);

private:
};

#endif // DOCUMENTITEMCOMMON_H
