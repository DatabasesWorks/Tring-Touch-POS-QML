#ifndef TAXCOMMON_H
#define TAXCOMMON_H

#include <QObject>
#include <QtSql>
#include <QString>

#include "headers/cTax.h"

class cTaxCommon : public QObject
{
    Q_OBJECT
public:
    explicit cTaxCommon(QObject *parent = 0);
    ~cTaxCommon() {}// qDebug() << "TaxCommon dying"; }

    static QString getTaxCode(qint32 itemId);
    static double getTaxRate(qint32 itemId);

public slots:   
    QList<QObject*> getTaxes(QString name);

    bool updateTax(cTax* tax, cTax* tTax);
    bool insertTax(cTax* tax);
    bool deleteTax(cTax* tax);

    cTax *getNewTax();
    qint32 getTaxIndex(qint32 id);

private:
    QList<QObject*> taxList;
    void fillTaxList();
    void insertItemIntoList(cTax* item);
    void updateItemFromList(cTax* tax, cTax* tTax);
};

#endif // TAXCOMMON_H
