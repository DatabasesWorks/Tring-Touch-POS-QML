#ifndef DOCUMENTITEM_H
#define DOCUMENTITEM_H

#include <QObject>
#include <QDateTime>
#include <QDebug>

class cDocumentItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY documentItemChanged)
    Q_PROPERTY(qint32 documentId READ documentId WRITE setDocumentId
               NOTIFY documentItemChanged)
    Q_PROPERTY(qint32 typeId READ typeId WRITE setTypeId
               NOTIFY documentItemChanged)
    Q_PROPERTY(qint32 itemId READ itemId WRITE setItemId
               NOTIFY documentItemChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY documentItemChanged)
    Q_PROPERTY(QString barcode READ barcode WRITE setBarcode
               NOTIFY documentItemChanged)
    Q_PROPERTY(QString unitOfMeasure READ unitOfMeasure WRITE setUnitOfMeasure
               NOTIFY documentItemChanged)
    Q_PROPERTY(qint32 taxId READ taxId WRITE setTaxId
               NOTIFY documentItemChanged)
    Q_PROPERTY(double taxP READ taxP WRITE setTaxP
               NOTIFY documentItemChanged)
    Q_PROPERTY(double priceWithTax READ priceWithTax WRITE setPriceWithTax
               NOTIFY documentItemChanged)
    Q_PROPERTY(double priceWithoutTax READ priceWithoutTax WRITE setPriceWithoutTax
               NOTIFY documentItemChanged)
    Q_PROPERTY(double priceWithDiscount READ priceWithDiscount WRITE setPriceWithDiscount
               NOTIFY documentItemChanged)
    Q_PROPERTY(double discountP READ discountP WRITE setDiscountP
               NOTIFY documentItemChanged)
    Q_PROPERTY(double output READ output WRITE setOutput
               NOTIFY documentItemChanged)
    Q_PROPERTY(double input READ input WRITE setInput
               NOTIFY documentItemChanged)
    Q_PROPERTY(double currentQuantity READ currentQuantity WRITE setCurrentQuantity
               NOTIFY documentItemChanged)
    Q_PROPERTY(QString customerTitle READ customerTitle WRITE setCustomerTitle
               NOTIFY documentItemChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate
               NOTIFY documentItemChanged)

    Q_DISABLE_COPY(cDocumentItem)

public:
    explicit cDocumentItem(QObject *parent = 0);
    cDocumentItem(qint32 id, qint32 documentId, qint32 typeId,
                  qint32 itemId, QString name, QString barcode, QString unitOfMeasure,
                  qint32 taxId, double taxP,
                  double priceWithTax, double priceWithoutTax,
                  double priceWithDiscount, double discountP, double discount,
                  double input, double output, double currentQuantity,
                  QString customerTitle, QDateTime date);
    ~cDocumentItem() {}

    qint32 id();
    void setId(qint32 id);

    qint32 documentId();
    void setDocumentId(qint32 documentId);

    qint32 typeId();
    void setTypeId(qint32 typeId);

    qint32 itemId();
    void setItemId(qint32 itemId);

    QString name();
    void setName(QString name);

    QString barcode();
    void setBarcode(QString barcode);

    QString unitOfMeasure();
    void setUnitOfMeasure(QString unitOfMeasure);

    qint32 taxId();
    void setTaxId(qint32 taxId);

    double taxP();
    void setTaxP(double taxP);

    double priceWithTax();
    void setPriceWithTax(double priceWithTax);

    double priceWithoutTax();
    void setPriceWithoutTax(double priceWithoutTax);

    double priceWithDiscount();
    void setPriceWithDiscount(double priceWithDiscount);

    double discountP();
    void setDiscountP(double discountP);

    double discount();
    void setDiscount(double discount);

    double output();
    void setOutput(double output);

    double input();
    void setInput(double input);

    double currentQuantity();
    void setCurrentQuantity(double currentQuantity);

    QString customerTitle();
    void setCustomerTitle(QString customerTitle);

    QDateTime date();
    void setDate(QDateTime date);

private:
    qint32 _id;
    qint32 _documentId;
    qint32 _typeId;
    qint32 _itemId;
    QString _name;
    QString _barcode;
    QString _unitOfMeasure;
    qint32 _taxId;
    double _taxP;
    double _priceWithTax;
    double _priceWithoutTax;
    double _priceWithDiscount;
    double _discountP;
    double _discount;
    double _output;
    double _input;
    double _currentQuantity;
    QString _customerTitle;
    QDateTime _date;

signals:
     void documentItemChanged();
};

Q_DECLARE_METATYPE(cDocumentItem*)

#endif // DOCUMENTITEM_H
