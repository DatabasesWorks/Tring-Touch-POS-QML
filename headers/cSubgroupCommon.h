#ifndef PODGRUPECOMMON_H
#define PODGRUPECOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cSubgroup.h"

class cSubgroupCommon : public QObject
{
    Q_OBJECT
public:
    explicit cSubgroupCommon(QObject *parent = 0);
    ~cSubgroupCommon() {}// qDebug() << "cSubgroupCommon dying"; }

public slots:  
    QList<QObject*> getSubgroups(QString name);
    QList<QObject *> getSubgroupsByGroup(qint32 group);

    bool insertSubgroup(cSubgroup* subgroup);
    bool deleteSubgroup(cSubgroup* subgroup);
    bool updateSubgroup(cSubgroup *subgroup, cSubgroup *tSubgroup);

    cSubgroup *getNewSubgroup();
    qint32 getNewId();

    qint32 getSubgroupIndex(qint32 id);
    qint32 getSubgroupIndex(qint32 id, QList<QObject *> list);

private:
    QList<QObject*> subgroupList;
    void fillSubgroupList();
    void insertItemIntoList(cSubgroup* subgroup);
};

#endif // PODGRUPECOMMON_H
