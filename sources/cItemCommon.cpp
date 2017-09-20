#include "headers/cItemCommon.h"
#include "headers/cItem.h"
#include "headers/cSqlCommon.h"
#include "headers/cCommon.h"

cItemCommon::cItemCommon(QObject *parent) :
    QObject(parent)
{
    fillItemList();
}

bool compareItemsByName(QObject* a, QObject* b)
{
    return (dynamic_cast<cItem*>(a))->name().toLower() < (dynamic_cast<cItem*>(b))->name().toLower();
}

void cItemCommon::fillItemList()
{
    QString sQuery("SELECT * FROM ITEMS");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cItem *item  = new cItem;
        item->setId(query.value("item_id").toInt());
        item->setBarcode(query.value("barcode").toString());
        item->setName(query.value("name").toString());
        item->setUnitOfMeasure(query.value("unit_of_measure").toString());
        item->setGroupId(query.value("group_id").toInt());
        item->setSubgroupId(query.value("subgroup_id").toInt());
        item->setPrice(query.value("price").toDouble());
        item->setTaxId(query.value("tax_id").toInt());
        item->setTop(query.value("top").toBool());
        itemList.append(item);
    }

    qSort(itemList.begin(), itemList.end(), compareItemsByName);
}

void cItemCommon::insertItemIntoList(cItem *item)
{
    itemList.append(new cItem(item->id(), item->barcode(), item->name(), item->unitOfMeasure(),
                               item->groupId(), item->subgroupId(),
                              item->price(), item->taxId(), item->top()));
    qSort(itemList.begin(), itemList.end(), compareItemsByName);
}

QList<QObject*> cItemCommon::getItems(QString name)
{
    if (name.isEmpty())
        return itemList;

    QList<QObject*> searchList;

    foreach (QObject* o, itemList)
    {
       cItem* p = dynamic_cast<cItem*>(o);
       if (p->name().toUpper().contains(name.toUpper())
               || p->barcode() == name)
       {
           searchList.append(o);
       }
    }

    return searchList;
}

qint32 cItemCommon::getNewId()
{
    return cSqlCommon::getNewId("ITEMS", "item_id");
}

QList<QObject *> cItemCommon::getTopItems(QString name)
{
    QList<QObject*> searchList;

    foreach (QObject* o, itemList)
    {
       cItem* p = dynamic_cast<cItem*>(o);

       if (p->top())
       {
           if (name.isEmpty())
               searchList.append(o);
           else
           {
               if (p->name().toUpper().contains(name.toUpper()))
                   searchList.append(o);
           }
       }
    }

    return searchList;
}

QList<QObject *> cItemCommon::getItemsByGroupSubgroup(QString name, qint32 group, qint32 subgroup)
{
    QList<QObject*> searchList;

    foreach (QObject* o, itemList)
    {
       cItem* p = dynamic_cast<cItem*>(o);
       if (p->groupId() == group && p->subgroupId() == subgroup)
       {
           if (name.isEmpty())
                searchList.append(o);
           else
           {
               if (p->name().toUpper().contains(name.toUpper()))
                   searchList.append(o);
           }
       }
    }

    return searchList;
}

void updateItemFromItemList(cItem* item, cItem *tItem)
{
    item->setId(tItem->id());
    item->setBarcode(tItem->barcode());
    item->setName(tItem->name());
    item->setGroupId(tItem->groupId());
    item->setSubgroupId(tItem->subgroupId());
    item->setTaxId(tItem->taxId());
    item->setPrice(tItem->price());
    item->setTop(tItem->top());
}

bool cItemCommon::updateItem(cItem* item, cItem *tItem)
{
    QString sQuery("UPDATE ITEMS SET item_id = :nid, barcode = :barcode, name = :name,"
                   " group_id = :group_id, subgroup_id = :subgroup_id, tax_id = :tax_id,"
                   " price = :price, top = :top,"
                   " modified = DATETIME('now'), modified_by = :modified_by"
                   " WHERE item_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tItem->id());
    query.bindValue(":barcode", tItem->barcode());
    query.bindValue(":name", tItem->name());
    query.bindValue(":group_id", tItem->groupId());
    query.bindValue(":subgroup_id", tItem->subgroupId());
    query.bindValue(":tax_id", tItem->taxId());
    query.bindValue(":price", tItem->price());
    query.bindValue(":top", tItem->top());
    query.bindValue(":id", item->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        updateItemFromItemList(item, tItem);
        qSort(itemList.begin(), itemList.end(), compareItemsByName);

        emit item->itemChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cItemCommon::insertItem(cItem* item)
{
    QString sQuery("INSERT INTO ITEMS (item_id, barcode, name, group_id,"
                   " subgroup_id, tax_id, price, top,"
                   " created, created_by)"
                   " VALUES (:id, :barcode, :name, :group_id,"
                   " :subgroup_id, :tax_id, :price, :top,"
                   " DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", item->id());
    query.bindValue(":barcode", item->barcode());
    query.bindValue(":name", item->name());
    query.bindValue(":group_id", item->groupId());
    query.bindValue(":subgroup_id", item->subgroupId());
    query.bindValue(":tax_id", item->taxId());
    query.bindValue(":price", item->price());
    query.bindValue(":top", item->top());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(item);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
    return res;
}

bool cItemCommon::deleteItem(cItem* item)
{
    QString sQuery("DELETE FROM ITEMS WHERE item_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":id", item->id());
    bool res = query.exec();
    if (res)
    {
        itemList.removeOne(item);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

cItem *cItemCommon::getNewItem()
{
    return new cItem();
}

cItem *cItemCommon::getItem(qint32 id)
{
    foreach (QObject* o, itemList)
    {
       cItem* p = dynamic_cast<cItem*>(o);
       if (p->id() == id)
       {
           return p;
       }
    }

    return new cItem();
}

cItem *cItemCommon::getItem(qint32 id, qint32 receipt_id)
{
    QString sQuery = "SELECT ITEMS.*, RECEIPT_ITEMS.Quantity " \
                    "FROM RECEIPT_ITEMS LEFT OUTER JOIN ITEMS " \
                    "ON RECEIPT_ITEMS.Item_id = ITEMS.ID " \
                    " WHERE ITEMS.ID = " + QString::number(id)
                    + " AND RECEIPT_ITEMS.Receipt_id = " + QString::number(receipt_id);

    QSqlQuery query1(sQuery);
    query1.exec();

    cItem *item = NULL;
    while(query1.next())
    {
        item = new cItem();
        item->setId(query1.value("item_id").toInt());
        item->setBarcode(query1.value("barcode").toString());
        item->setName(query1.value("name").toString());
        item->setGroupId(query1.value("group_id").toInt());
        item->setSubgroupId(query1.value("subgroup_id").toInt());
        item->setPrice(query1.value("price").toDouble());
        item->setTaxId(query1.value("tax_id").toInt());
        item->setTop(query1.value("top").toBool());
    }

    return item;
}

void cItemCommon::setTopItem(cItem *item)
{
    QString sQuery("UPDATE ITEMS SET top = :top, "
                   " modified = DATETIME('now'), modified_by = :modified_by "
                   " WHERE item_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":top", !item->top());
    query.bindValue(":id", item->id());
    query.bindValue(":modified_by", cCommon::cashier->id());
    bool res = query.exec();
    if (res)
    {
        item->setTop(!item->top());
        emit item->itemChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
}

bool cItemCommon::updateItemById(qint32 itemId, QString unitOfMeasure, double price)
{
    QString sQuery("UPDATE ITEMS SET price = :price, unit_of_measure = :unit,"
                   " modified = DATETIME('now'), modified_by = :modified_by "
                   " WHERE item_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":price", price);
    query.bindValue(":unit", unitOfMeasure);
    query.bindValue(":id", itemId);
    query.bindValue(":modified_by", cCommon::cashier->id());
    bool res = query.exec();
    if (res)
    {
        cItem* item = getItem(itemId);
        item->setPrice(price);
        item->setUnitOfMeasure(unitOfMeasure);
        item->itemChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }
    return res;
}
