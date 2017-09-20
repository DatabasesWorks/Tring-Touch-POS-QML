#ifndef TAX_H
#define TAX_H

#include <QObject>
#include <QString>
#include <QDebug>

class cTax : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY taxChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY taxChanged)
    Q_PROPERTY(double taxRate READ taxRate WRITE setTaxRate
               NOTIFY taxChanged)
    Q_PROPERTY(QString code READ code WRITE setCode
               NOTIFY taxChanged)
public:
    explicit cTax(QObject *parent = 0);
    cTax(qint32 id, QString name, double taxRate, QString code);
    ~cTax() {}// qDebug() << "cTax dying"; }

    qint32 id();
    void setId(qint32 id);

    QString name();
    void setName(QString name);

    double taxRate();
    void setTaxRate(double taxRate);

    QString code();
    void setCode(QString code);
private:
    qint32 _id;
    QString _name;
    double _taxRate;
    QString _code;

signals:
     void taxChanged();

};

Q_DECLARE_METATYPE(cTax*)

#endif // TAX_H
