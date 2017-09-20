#ifndef CASHIER_H
#define CASHIER_H

#include <QObject>
#include <QString>

class cCashier : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY cashierChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY cashierChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword
               NOTIFY cashierChanged)
public:
    explicit cCashier(QObject *parent = 0);
    cCashier(qint32 id, QString name, QString password, qint32 roleId);
    ~cCashier() {}// qDebug() << "Cashier dying"; }

    qint32 id();
    void setId(qint32 id);

    QString name();
    void setName(QString name);

    QString password();
    void setPassword(QString password);

    qint32 roleId();
    void setRoleId(qint32 roleId);
private:
    qint32 _id;
    QString _name;
    QString _password;
    qint32 _roleId;
signals:
     void cashierChanged();
public slots:

};

Q_DECLARE_METATYPE(cCashier*)

#endif // CASHIER_H
