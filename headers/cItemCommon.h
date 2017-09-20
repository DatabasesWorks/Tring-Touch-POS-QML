#ifndef ITEMCOMMON_H
#define ITEMCOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cItem.h"

class cItemCommon : public QObject
{
    Q_OBJECT
public:
    explicit cItemCommon(QObject *parent = 0);
    ~cItemCommon() {}// qDebug() << "ItemCommon dying"; }

signals:

public slots:
    QList<QObject*> getItems(QString name);
    QList<QObject*> getTopItems(QString name);
    QList<QObject*> getItemsByGroupSubgroup(QString name, qint32 group, qint32 subgroup);
    qint32 getNewId();

    bool updateItem(cItem* item, cItem *tItem);
    bool insertItem(cItem* item);
    bool deleteItem(cItem* item);

    cItem *getNewItem();
    cItem *getItem(qint32 id);
    cItem *getItem(qint32 id, qint32 receipt_id);
    void setTopItem(cItem* item);

    bool updateItemById(qint32 itemId, QString unitOfMeasure, double price);

private:
    QList<QObject*> itemList;
    void fillItemList();
    void updateListItem(cItem *item);
    void insertItemIntoList(cItem* item);
};

#endif // ITEMCOMMON_H
