#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cCustomerCommon.h"

cCustomerCommon::cCustomerCommon(QObject *parent) :
    QObject(parent)
{
    fillCustomerList();
}

bool compareCustomersByLine1(QObject* customerA, QObject* customerB)
{
    return (dynamic_cast<cCustomer*>(customerA))->line1() > (dynamic_cast<cCustomer*>(customerB))->line1();
}

void cCustomerCommon::fillCustomerList()
{
    QString sQuery("SELECT * FROM CUSTOMERS");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << "> fillCustomerList: " << query.lastError();
    }

    while(query.next()){
        cCustomer *customer = new cCustomer;
        customer->setId(query.value("customer_id").toInt());
        customer->setIdc(query.value("idc").toString());
        customer->setVatNumber(query.value("vat_number").toString());
        customer->setLine1(query.value("line_1").toString());
        customer->setLine2(query.value("line_2").toString());
        customer->setLine3(query.value("line_3").toString());
        customer->setLine4(query.value("line_4").toString());
        customerList.append(customer);
    }

    qSort(customerList.begin(), customerList.end(), compareCustomersByLine1);
}

QList<QObject*> cCustomerCommon::getCustomers(QString name)
{
    if (name.isEmpty())
    {
        return customerList;
    }


    QList<QObject*> searchList;

    foreach (QObject* o, customerList)
    {
       cCustomer* pC = dynamic_cast<cCustomer*>(o);
       if (pC->line1().toUpper().contains(name.toUpper()) || pC->idc() == name)
       {
           searchList.append(o);
       }
    }

    return searchList;
}

void updateItemFromCustomerList(cCustomer* customer, cCustomer *tCustomer)
{
    customer->setId(tCustomer->id());
    customer->setIdc(tCustomer->idc());
    customer->setLine1(tCustomer->line1());
    customer->setLine2(tCustomer->line2());
    customer->setLine3(tCustomer->line3());
    customer->setLine4(tCustomer->line4());
}

bool cCustomerCommon::updateCustomer(cCustomer* customer, cCustomer *tCustomer)
{
    QString sQuery("UPDATE CUSTOMERS SET customer_id = :nid, idc = :idc, vat_number = :vat_number,"
                   " line_1 = :line_1, line_2 = :line_2, line_3 = :line_3,"
                   " line_4 = :line_4, modified = DATETIME('now'),"
                   " modified_by = :modified_by WHERE customer_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tCustomer->id());
    query.bindValue(":idc", tCustomer->idc());
    query.bindValue(":vat_number", tCustomer->vat_number());
    query.bindValue(":line_1", tCustomer->line1());
    query.bindValue(":line_2", tCustomer->line2());
    query.bindValue(":line_3", tCustomer->line3());
    query.bindValue(":line_4", tCustomer->line4());
    query.bindValue(":id", customer->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        updateItemFromCustomerList(customer, tCustomer);
        qSort(customerList.begin(), customerList.end(), compareCustomersByLine1);
        emit customer->customerChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

void cCustomerCommon::insertItemIntoList(cCustomer* customer)
{
    customerList.append(new cCustomer(customer->id(), customer->idc(), customer->line1(), customer->line2(),
                                      customer->line3(), customer->line4()));
    qSort(customerList.begin(), customerList.end(), compareCustomersByLine1);
}

bool cCustomerCommon::insertCustomer(cCustomer* customer)
{
    QString sQuery("INSERT INTO CUSTOMERS (customer_id, idc, vat_number, line_1,"
                    " line_2, line_3, line_4, created, created_by)"
                    " VALUES (:id, :idc, :vat_number, :line_1,"
                    " :line_2, :line_3, :line_4, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", customer->id());
    query.bindValue(":idc", customer->idc());
    query.bindValue(":vat_number", customer->vat_number());
    query.bindValue(":line_1", customer->line1());
    query.bindValue(":line_2", customer->line2());
    query.bindValue(":line_3", customer->line3());
    query.bindValue(":line_4", customer->line4());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(customer);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}


bool cCustomerCommon::deleteCustomer(cCustomer* customer)
{
    QString sQuery("DELETE FROM CUSTOMERS WHERE customer_id = " + QString::number(customer->id()));
    QSqlQuery query(sQuery);
    bool res = query.exec();
    if (res)
    {
        customerList.removeOne(customer);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

cCustomer *cCustomerCommon::getNewCustomer()
{
    return new cCustomer();
}

qint32 cCustomerCommon::getNewId()
{
    return cSqlCommon::getNewId("CUSTOMERS", "customer_id");
}

qint32 cCustomerCommon::getCustomerIndex(qint32 id)
{
    foreach (QObject* c, customerList) {
       if (dynamic_cast<cCustomer*>(c)->id() == id)
           return customerList.indexOf(c);
    }
    return -1;
}

cCustomer *cCustomerCommon::getCustomer(qint32 id)
{
    foreach (QObject* c, customerList)
    {
       cCustomer* pC = dynamic_cast<cCustomer*>(c);
       if (pC->id() == id)
       {
           return pC;
       }
    }

    return new cCustomer();
}

QString cCustomerCommon::customerGetLine1(qint32 id)
{
    foreach (QObject* c, customerList)
    {
       cCustomer* pC = dynamic_cast<cCustomer*>(c);
       if (pC->id() == id)
       {
           return pC->line1();
       }
    }
    return "";
}
