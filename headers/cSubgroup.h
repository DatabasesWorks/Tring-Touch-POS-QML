#ifndef SUBGROUP_H
#define SUBGROUP_H

#include <QObject>
#include <QString>
#include <QDebug>

class cSubgroup : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY subgroupChanged)
    Q_PROPERTY(qint32 groupId READ groupId WRITE setGroupId
               NOTIFY subgroupChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY subgroupChanged)
public:
    explicit cSubgroup(QObject *parent = 0);
    cSubgroup(qint32 id, QString name, qint32 groupId);
    ~cSubgroup() {}// qDebug() << "Subgroup dying"; }

    qint32 id();
    void setId(qint32 id);

    QString name();
    void setName(QString name);

    qint32 groupId();
    void setGroupId(qint32 groupId);

private:
    qint32 _id;
    QString _name;
    qint32 _groupId;

signals:
     void subgroupChanged();
};

Q_DECLARE_METATYPE(cSubgroup*)

#endif // SUBGROUP_H
