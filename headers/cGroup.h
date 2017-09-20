#ifndef GROUP_H
#define GROUP_H

#include <QObject>
#include <QString>
#include <QDebug>

class cGroup : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY groupChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY groupChanged)
public:
    explicit cGroup(QObject *parent = 0);
    cGroup(qint32 id, QString name);
    ~cGroup() {}// qDebug() << "cGroup dying"; }

    qint32 id();
    void setId(qint32 id);

    QString name();
    void setName(QString name);

private:
    qint32 _id;
    QString _name;

signals:
     void groupChanged();
};

Q_DECLARE_METATYPE(cGroup*)

#endif // GROUP_H
