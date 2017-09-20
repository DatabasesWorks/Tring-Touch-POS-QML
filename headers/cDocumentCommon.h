#ifndef DOCUMENTCOMMON_H
#define DOCUMENTCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cCustomer.h"
#include "headers/cDocumentItemCommon.h"
#include "headers/cDocument.h"

class cDocumentCommon : public QObject
{
    Q_OBJECT
public:
    explicit cDocumentCommon(QObject *parent = 0);
    ~cDocumentCommon() {}

public slots:
    cDocument * getNewDocument(qint32 documentTypeId);
    qint32 getNewDocumentId();

    bool documentInsert(cDocument *document, QList<QObject*> documentItems, bool isReclaimReceipt);
    bool documentDelete(cDocument *document);

private:
    bool documentDbInsert(cDocument *document);
    bool documentDbDelete(cDocument *document);
};

#endif // DOCUMENTCOMMON_H
