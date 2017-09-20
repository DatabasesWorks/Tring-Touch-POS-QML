#ifndef PAPERWIDTH_H
#define PAPERWIDTH_H

#include <QObject>
#include <QDebug>

class cPaperWidth : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName
               NOTIFY nameChanged)
    Q_PROPERTY(qint32 value READ value WRITE setValue
               NOTIFY valueChanged)

public:
    cPaperWidth(QObject *parent=0);
    cPaperWidth(const QString &name, qint32 value, QObject *parent=0);
    ~cPaperWidth() {}// qDebug() << "PaperWidth dying"; }

    QString name() const;
    void setName(const QString &name);

    qint32 value();
    void setValue(qint32 value);

signals:
    void nameChanged();
    void valueChanged();

private:
    QString _name;
    qint32 _value;
};


#endif // PAPERWIDTH_H
