#include <QtSql>

#include "headers/cCommon.h"
#include "headers/cTaxCommon.h"

cTaxCommon::cTaxCommon(QObject *parent) :
    QObject(parent)
{
    fillTaxList();
}

bool compareTaxesById(QObject* taxA, QObject* taxB)
{
    return (dynamic_cast<cTax*>(taxA))->id() < (dynamic_cast<cTax*>(taxB))->id();
}

void cTaxCommon::fillTaxList()
{
    QString sQuery("SELECT * FROM TAXES");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cTax *tax = new cTax;
        tax->setId(query.value("tax_id").toInt());
        tax->setName(query.value("name").toString());
        tax->setTaxRate(query.value("tax_rate").toDouble());
        tax->setCode(query.value("code").toString());
        taxList.append(tax);
    }

    qSort(taxList.begin(), taxList.end(), compareTaxesById);
}

void cTaxCommon::insertItemIntoList(cTax *item)
{
    taxList.append(new cTax(item->id(), item->name(), item->taxRate(), item->code()));
    qSort(taxList.begin(), taxList.end(), compareTaxesById);
}

void cTaxCommon::updateItemFromList(cTax *tax, cTax *tTax)
{
    tax->setId(tTax->id());
    tax->setName(tTax->name());
    tax->setTaxRate(tTax->taxRate());
    tax->setCode(tTax->code());
}

QList<QObject *> cTaxCommon::getTaxes(QString name)
{
    if (name.isEmpty())
    {
        return taxList;
    }

    QList<QObject*> searchList;

    foreach (QObject* o, taxList)
    {
       cTax* p = dynamic_cast<cTax*>(o);
       if (p->name().toUpper().contains(name.toUpper()))
       {
           searchList.append(o);
       }
    }

    return searchList;
}

bool cTaxCommon::updateTax(cTax* tax, cTax* tTax)
{
    QString sQuery("UPDATE TAXES SET tax_id = :nid, name = :name,"
                   " tax_rate = :tax_rate, code = :code,"
                   " modified = DATETIME('now'), modified_by = :modified_by"
                   " WHERE tax_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tTax->id());
    query.bindValue(":name", tTax->name());
    query.bindValue(":tax_rate", tTax->taxRate());
    query.bindValue(":code", tTax->code());
    query.bindValue(":id", tax->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        updateItemFromList(tax, tTax);
        qSort(taxList.begin(), taxList.end(), compareTaxesById);
        emit tax->taxChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cTaxCommon::insertTax(cTax *tax)
{
    QString sQuery("INSERT INTO TAXES (tax_id, name, tax_rate, code, created, created_by)"
                      "VALUES (:id, :name, :tax_rate, :code, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":name", tax->name());
    query.bindValue(":tax_rate", tax->taxRate());
    query.bindValue(":code", tax->code());
    query.bindValue(":id", tax->id());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(tax);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
    return res;
}

bool cTaxCommon::deleteTax(cTax *tax)
{
    QString sQuery("DELETE FROM TAXES WHERE tax_id = " + QString::number(tax->id()));
    QSqlQuery query(sQuery);
    bool res = query.exec();
    if (res)
    {
        taxList.removeOne(tax);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

cTax *cTaxCommon::getNewTax()
{
    return new cTax();
}

qint32 cTaxCommon::getTaxIndex(qint32 id)
{   
    foreach (QObject* p, taxList) {
       if (dynamic_cast<cTax*>(p)->id() == id)
        {
           return taxList.indexOf(p);
       }
    }
    return -1;
}

QString cTaxCommon::getTaxCode(qint32 itemId)
{
    QString code = "";

    QString sQuery("SELECT IFNULL(Code, "") FROM TAXES LEFT JOIN ITEMS"
                    " ON TAXES.tax_id = ITEMS.Tax_id WHERE ITEMS.item_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", itemId);

    if (query.exec())
    {
        while(query.next())
        {
            code = query.value(0).toString();
            return code;
        }
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

   return code;
}

double cTaxCommon::getTaxRate(qint32 itemId)
{
    double tax_rate = 0.0;

    QString sQuery("SELECT IFNULL(Tax_rate, -1) FROM TAXES LEFT JOIN ITEMS"
                    " ON TAXES.Tax_id = ITEMS.Tax_id WHERE ITEMS.item_id = :id");

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", itemId);

    if (query.exec())
    {
        while(query.next())
        {
            tax_rate = query.value(0).toDouble();
            return tax_rate;
        }
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

   return tax_rate;
}

