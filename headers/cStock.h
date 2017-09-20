#ifndef CSTOCK_H
#define CSTOCK_H

#include <QObject>
#include <QString>
#include <QDateTime>
#include "cDocumentItem.h"

class cStock : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY stockChanged)
    Q_PROPERTY(qint32 itemId READ itemId WRITE setItemId
               NOTIFY stockChanged)
    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY stockChanged)
    Q_PROPERTY(QString unitOfMeasure READ unitOfMeasure WRITE setUnitOfMeasure
               NOTIFY stockChanged)
    Q_PROPERTY(double input READ input WRITE setInput
               NOTIFY stockChanged)
    Q_PROPERTY(double output READ output WRITE setOutput
               NOTIFY stockChanged)
    Q_PROPERTY(double sum READ sum WRITE setSum
               NOTIFY stockChanged)
    Q_PROPERTY(double price READ price WRITE setPrice
               NOTIFY stockChanged)
    Q_PROPERTY(qint32 documentId READ documentId WRITE setDocumentId
               NOTIFY stockChanged)
public:
    explicit cStock(QObject *parent = 0);
    ~cStock() {}

    qint32 id();
    void setId(qint32 id);

    qint32 itemId();
    void setItemId(qint32 itemId);

    QString name();
    void setName(QString name);

    QString unitOfMeasure();
    void setUnitOfMeasure(QString unitOfMeasure);

    double input();
    void setInput(double input);

    double output();
    void setOutput(double input);

    double sum();
    void setSum(double sum);

    double price();
    void setPrice(double price);

    qint32 documentId();
    void setDocumentId(qint32 documentId);

private:
    qint32 _id;
    qint32 _itemId;
    QString _name;
    QString _unitOfMeasure;
    double _input;
    double _output;
    double _sum;
    double _price;
    qint32 _documentId;

signals:
     void stockChanged();
public slots:

};

Q_DECLARE_METATYPE(cStock*)

#endif // CSTOCK_H
