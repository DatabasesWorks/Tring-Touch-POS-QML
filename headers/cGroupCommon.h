#ifndef GRUPECOMMON_H
#define GRUPECOMMON_H

#include <QObject>
#include <QtSql>

#include "headers/cGroup.h"

class cGroupCommon : public QObject
{
    Q_OBJECT
public:
    explicit cGroupCommon(QObject *parent = 0);
    ~cGroupCommon() {}// qDebug() << "GroupCommon dying"; }

public slots:
    QList<QObject*> getGroups(QString name);

    bool updateGroup(cGroup* group, cGroup *tGroup);
    bool insertGroup(cGroup* gru);
    bool deleteGroup(cGroup* gru);

    cGroup *getNewGroup();
    qint32 getNewId();

    qint32 getGroupIndex(qint32 id);

private:
    QList<QObject*> groupList;
    void fillGroupList();
    void insertItemIntoList(cGroup* group);
};

#endif // GRUPECOMMON_H
