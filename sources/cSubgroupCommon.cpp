#include "headers/cCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cSubgroupCommon.h"

cSubgroupCommon::cSubgroupCommon(QObject *parent) :
    QObject(parent)
{
    fillSubgroupList();
}

bool compareSubgroupByName(QObject* subroupA, QObject* subgroupB)
{
    return (dynamic_cast<cSubgroup*>(subroupA))->name() > (dynamic_cast<cSubgroup*>(subgroupB))->name();
}

void cSubgroupCommon::fillSubgroupList()
{
    QString sQuery("SELECT * FROM SUBGROUPS");
    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

   while(query.next())
   {
       cSubgroup *sgroup = new cSubgroup;
       sgroup->setId(query.value("subgroup_id").toInt());
       sgroup->setGroupId(query.value("group_id").toInt());
       sgroup->setName(query.value("name").toString());
       subgroupList.append(sgroup);
   }

   qSort(subgroupList.begin(), subgroupList.end(), compareSubgroupByName);
}

void cSubgroupCommon::insertItemIntoList(cSubgroup *subgroup)
{
    subgroupList.append(new cSubgroup(subgroup->id(), subgroup->name(), subgroup->groupId()));
    qSort(subgroupList.begin(), subgroupList.end(), compareSubgroupByName);
}

QList<QObject *> cSubgroupCommon::getSubgroups(QString name)
{
    if (name.isEmpty())
    {
        return subgroupList;
    }

    QList<QObject*> searchList;

    foreach (QObject* o, subgroupList)
    {
       cSubgroup* p = dynamic_cast<cSubgroup*>(o);
       if (p->name().toUpper().contains(name.toUpper()))
       {
           searchList.append(o);
       }
    }

    return searchList;
}

QList<QObject *> cSubgroupCommon::getSubgroupsByGroup(qint32 group)
{
    QList<QObject*> searchList;

    foreach (QObject* o, subgroupList)
    {
       cSubgroup* p = dynamic_cast<cSubgroup*>(o);
       if (p->groupId() == group)
       {
           searchList.append(o);
       }
    }

    return searchList;
}

void updateItemFromSubgroupList(cSubgroup* subgroup, cSubgroup *tSubgroup)
{
    subgroup->setId(tSubgroup->id());
    subgroup->setName(tSubgroup->name());
    subgroup->setGroupId(tSubgroup->groupId());
}

bool cSubgroupCommon::updateSubgroup(cSubgroup* subgroup, cSubgroup *tSubgroup)
{
    QString sQuery("UPDATE SUBGROUPS SET subgroup_id = :nid, name = :name, group_id = :group_id,"
                   " modified = DATETIME('now'), modified_by = :modified_by"
                   " WHERE subgroup_id = :id");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":nid", tSubgroup->id());
    query.bindValue(":name", tSubgroup->name());
    query.bindValue(":group_id", tSubgroup->groupId());
    query.bindValue(":id", subgroup->id());
    query.bindValue(":modified_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        updateItemFromSubgroupList(subgroup, tSubgroup);
        qSort(subgroupList.begin(), subgroupList.end(), compareSubgroupByName);
        emit subgroup->subgroupChanged();
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}



bool cSubgroupCommon::insertSubgroup(cSubgroup *subgroup)
{
    QString sQuery("INSERT INTO SUBGROUPS (subgroup_id, name, group_id, created, created_by)"
                    " VALUES (:id, :name, :group_id, DATETIME('now'), :created_by)");
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue(":name", subgroup->name());
    query.bindValue(":group_id", subgroup->id());
    query.bindValue(":id", subgroup->id());
    query.bindValue(":created_by", cCommon::cashier->id());

    bool res = query.exec();
    if (res)
    {
        insertItemIntoList(subgroup);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

bool cSubgroupCommon::deleteSubgroup(cSubgroup *subgroup)
{
    QString sQuery("DELETE FROM SUBGROUPS WHERE subgroup_id = " + QString::number(subgroup->id()));
    QSqlQuery query(sQuery);
    bool res = query.exec();
    if (res)
    {
        subgroupList.removeOne(subgroup);
    }
    else
    {
        qDebug() << __FUNCTION__ << ":" << query.lastError();
    }

    return res;
}

cSubgroup *cSubgroupCommon::getNewSubgroup()
{
    return new cSubgroup();
}

qint32 cSubgroupCommon::getNewId()
{
    return cSqlCommon::getNewId("SUBGROUPS", "subgroup_id");
}

qint32 cSubgroupCommon::getSubgroupIndex(qint32 id)
{
    foreach (QObject* pg, subgroupList) {
       if (dynamic_cast<cSubgroup*>(pg)->id() == id)
           return subgroupList.indexOf(pg);
    }
    return 0;
}

qint32 cSubgroupCommon::getSubgroupIndex(qint32 id, QList<QObject *> list)
{
    foreach (QObject* pg, list) {
       if (dynamic_cast<cSubgroup*>(pg)->id() == id)
           return list.indexOf(pg);
    }
    return 0;
}

