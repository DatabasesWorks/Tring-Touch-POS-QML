#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
#include <QDateTime>
#include <QString>
#include <QDebug>

class cDocument : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 id READ id WRITE setId
               NOTIFY documentChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle
               NOTIFY documentChanged)
    Q_PROPERTY(qint32 customerId READ customerId WRITE setCustomerId
               NOTIFY documentChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate
               NOTIFY documentChanged)
    Q_PROPERTY(double cash READ cash WRITE setCash
               NOTIFY documentChanged)
    Q_PROPERTY(double check READ check WRITE setCheck
               NOTIFY documentChanged)
    Q_PROPERTY(double card READ card WRITE setCard
               NOTIFY documentChanged)
    Q_PROPERTY(double transferOrder READ transferOrder WRITE setTransferOrder
               NOTIFY documentChanged)
    Q_PROPERTY(qint32 fiscalNumber READ fiscalNumber WRITE setFiscalNumber
               NOTIFY documentChanged)
    Q_PROPERTY(qint32 reclaimedNumber READ reclaimedNumber WRITE setReclaimedNumber
               NOTIFY documentChanged)
    Q_PROPERTY(QString note READ note WRITE setNote
               NOTIFY documentChanged)
    Q_PROPERTY(qint32 total READ total WRITE setTotal
               NOTIFY documentChanged)

public:
    explicit cDocument(QObject *parent = 0);
    cDocument(qint32 id, qint32 typeId, QString title, qint32 customerId, QDateTime date, double cash, double check,
             double card, double transferOrder, qint32 fiscalNumber, qint32 reclaimedNumber,
             QString note, qint32 total);
    ~cDocument() {}// qDebug() << "Receipt dying"; }

    qint32 id();
    void setId(qint32 id);

    qint32 typeId();
    void setTypeId(qint32 typeId);

    QString title();
    void setTitle(QString title);

    qint32 customerId();
    void setCustomerId(qint32 customerId);

    QDateTime date();
    void setDate(QDateTime date);

    double cash();
    void setCash(double cash);

    double check();
    void setCheck(double check);

    double card();
    void setCard(double card);

    double transferOrder();
    void setTransferOrder(double transferOrder);

    qint32 fiscalNumber();
    void setFiscalNumber(qint32 fiscalNumber);

    qint32 reclaimedNumber();
    void setReclaimedNumber(qint32 reclaimedNumber);

    double total();
    void setTotal(double total);

    QString note();
    void setNote(QString note);

private:
    qint32 _id;
    qint32 _typeId;
    QString _title;
    qint32 _customerId;
    QDateTime _date;
    QString _currency;
    double _cash;
    double _check;
    double _card;
    double _transferOrder;
    qint32 _fiscalNumber;
    qint32 _reclaimedNumber;
    double _total;
    QString _note;

signals:
    void documentChanged();

};

Q_DECLARE_METATYPE(cDocument*)

#endif // DOCUMENT_H
