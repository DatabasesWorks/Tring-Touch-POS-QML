#ifndef ITEM_H
#define ITEM_H

#include <QDateTime>
#include <QDebug>

class cItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY itemChanged)
    Q_PROPERTY(QString barcode READ barcode WRITE setBarcode
               NOTIFY itemChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY itemChanged)
    Q_PROPERTY(QString unitOfMeasure READ unitOfMeasure WRITE setUnitOfMeasure
               NOTIFY itemChanged)
    Q_PROPERTY(qint32 groupId READ groupId WRITE setGroupId
               NOTIFY itemChanged)
    Q_PROPERTY(qint32 subgroupId READ subgroupId WRITE setSubgroupId
               NOTIFY itemChanged)
    Q_PROPERTY(double price READ price WRITE setPrice
               NOTIFY itemChanged)
    Q_PROPERTY(qint32 taxId READ taxId WRITE setTaxId
               NOTIFY itemChanged)
    Q_PROPERTY(bool top READ top WRITE setTop
               NOTIFY itemChanged)

public:
    explicit cItem(QObject *parent = 0);
    cItem(qint32 id, QString barcode, QString name, QString unitOfMeasure,
          qint32 groupId, qint32 subgroupId,
          double price, qint32 taxId, bool top);
    ~cItem() {}

    qint32 id() const;
    void setId(const qint32 id);

    QString barcode() const;
    void setBarcode(const QString barcode);

    QString name() const;
    void setName(const QString name);

    QString unitOfMeasure() const;
    void setUnitOfMeasure(const QString unitOfMeasure);

    qint32 groupId() const;
    void setGroupId(const qint32 groupId);

    qint32 subgroupId() const;
    void setSubgroupId(const qint32 subgroupId);

    double price() const;
    void setPrice(const double price);

    qint32 taxId() const;
    void setTaxId(const qint32 taxId);

    bool top() const;
    void setTop(const bool top);

private:
    qint32 _id;
    QString _barcode;
    QString _name;
    QString _unitOfMeasure;
    qint32 _groupId;
    qint32 _subgroupId;
    double _price;
    qint32 _taxId;
    bool _top;

signals:
     void itemChanged();

};

Q_DECLARE_METATYPE(cItem*)

#endif // ITEM_H
