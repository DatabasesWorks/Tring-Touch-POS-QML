#ifndef CUSTOMER_H
#define CUSTOMER_H

#include <QObject>
#include <QString>
#include <QDateTime>
#include <QDebug>

class cCustomer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY customerChanged)
    Q_PROPERTY(QString idc READ idc WRITE setIdc
               NOTIFY customerChanged)
    Q_PROPERTY(QString vat_number READ vat_number WRITE setVatNumber
               NOTIFY customerChanged)
    Q_PROPERTY(QString line1 READ line1 WRITE setLine1
               NOTIFY customerChanged)
    Q_PROPERTY(QString line2 READ line2 WRITE setLine2
               NOTIFY customerChanged)
    Q_PROPERTY(QString line3 READ line3 WRITE setLine3
               NOTIFY customerChanged)
    Q_PROPERTY(QString line4 READ line4 WRITE setLine4
               NOTIFY customerChanged)
//    Q_PROPERTY(QDateTime created READ created WRITE setCreated
//               NOTIFY customerChanged)
//    Q_PROPERTY(qint32 createdBy READ createdBy WRITE setCreatedBy
//               NOTIFY customerChanged)
//    Q_PROPERTY(QDateTime modified READ modified WRITE setModified
//               NOTIFY customerChanged)
//    Q_PROPERTY(qint32 modifiedBy READ modifiedBy WRITE setModifiedBy
//               NOTIFY customerChanged)
public:
    explicit cCustomer(QObject *parent = 0);
    cCustomer(qint32 id, QString idc, QString line1, QString line2,
              QString line3, QString line4);
    ~cCustomer() {}// qDebug() << "Customer dying"; }

    qint32 id();
    void setId(qint32 id);

    QString idc();
    void setIdc(QString idc);

    QString vat_number();
    void setVatNumber(QString vat_number);

    QString line1();
    void setLine1(QString line1);

    QString line2();
    void setLine2(QString line2);

    QString line3();
    void setLine3(QString line3);

    QString line4();
    void setLine4(QString line4);

//    QDateTime created();
//    void setCreated(QDateTime created);

//    qint32 createdBy();
//    void setCreatedBy(qint32 createdBy);

//    QDateTime modified();
//    void setModified(QDateTime modified);

//    qint32 modifiedBy();
//    void setModifiedBy(qint32 modifiedBy);

private:
    qint32 _id;
    QString _idc;
    QString _vatNumber;
    QString _line1;
    QString _line2;
    QString _line3;
    QString _line4;
//    QDateTime _created;
//    qint32 _createdBy;
//    QDateTime _modified;
//    qint32 _modifiedBy;

signals:
     void customerChanged();
};

Q_DECLARE_METATYPE(cCustomer*)

#endif // CUSTOMER_H
