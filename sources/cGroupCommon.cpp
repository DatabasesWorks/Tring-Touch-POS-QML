#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cGroupCommon.h"

cGroupCommon::cGroupCommon(QObject *parent) :
    QObject(parent)
{
    fillGroupList();
}

bool compareGroupByName(QObject* groupA, QObject* groupB)
{
    return (dynamic_cast<cGroup*>(groupA))->name() > (dynamic_cast<cGroup*>(groupB))->name();
}

void cGroupCommon::fillGroupList()
{
    QString sQuery("SELECT * FROM GROUPS");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    while(query.next())
    {
        cGroup *group = new cGroup;
        group->setId(query.value("group_id").toInt());
        group->setName(query.value("name").toString());
        groupList.append(group);
    }

    qSort(groupList.begin(), groupList.end(), compareGroupByName);
}

void cGroupCommon::insertItemIntoList(cGroup *group)
{
    groupList.append(new cGroup(group->id(), group->name()));
    qSort(groupList.begin(), groupList.end(), compareGroupByName);
}

QList<QObject *> cGroupCommon::getGroups(QString name)
{
    if (name.isEmpty())
    {
        return groupList;
    }

    QList<QObject*> searchList;

    foreach (QObject* o, groupList)
    {
       cGroup* p = dynamic_cast<cGroup*>(o);
       if (p->name().toUpper().contains(name.toUpper()))
       {
           searchList.append(o);
       }
    }

    return searchList;
}

void updateItemFromGroupList(cGroup* group, cGroup *tGroup)
{
    group->setId(tGroup->id());
    group->setName(tGroup->name());
}

bool cGroupCommon::updateGroup(cGroup *group, cGroup *tGroup)
{
    QString sQuery("UPDATE GROUPS SET group_id = :nid, name = :name,"
                   " modified = DATETIME('now'), modified_by = :modified_by"
                   " WHERE group_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tGroup->id());
    query.bindValue(":name", tGroup->name());
    query.bindValue(":id", group->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        updateItemFromGroupList(group, tGroup);
        qSort(groupList.begin(), groupList.end(), compareGroupByName);
        emit group->groupChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cGroupCommon::insertGroup(cGroup *gru)
{
    QString sQuery("INSERT INTO GROUPS (group_id, name, created, created_by) "
                   " VALUES (:id, :name, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":name", gru->name());
    query.bindValue(":id", gru->id());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(gru);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cGroupCommon::deleteGroup(cGroup *gru)
{
    QString sQuery("DELETE FROM GROUPS WHERE group_id = " + QString::number(gru->id()));
    QSqlQuery query(sQuery);
    bool res = query.exec();
    if (res)
    {
        groupList.removeOne(gru);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

cGroup *cGroupCommon::getNewGroup()
{
    return new cGroup();
}

qint32 cGroupCommon::getNewId()
{
    return cSqlCommon::getNewId("GROUPS", "group_id");
}

qint32 cGroupCommon::getGroupIndex(qint32 id)
{
    foreach (QObject* g, groupList) {
       if (dynamic_cast<cGroup*>(g)->id() == id)
           return groupList.indexOf(g);
    }
    return 0;
}
