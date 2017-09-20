#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QString>
#include <QDateTime>
#include <QDebug>

class cSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint32 paperWidth READ paperWidth WRITE setPaperWidth
               NOTIFY settingsChanged)
    Q_PROPERTY(QString portNo READ portNo WRITE setPortNo
               NOTIFY settingsChanged)
    Q_PROPERTY(QString port READ port WRITE setPort
               NOTIFY settingsChanged)
    Q_PROPERTY(qint32 unit READ unit WRITE setUnit
               NOTIFY settingsChanged)
    Q_PROPERTY(bool noteCashier READ noteCashier WRITE setNoteCashier
               NOTIFY settingsChanged)
    Q_PROPERTY(QString notePredefined READ notePredefined WRITE setNotePredefined
               NOTIFY settingsChanged)

public:
    explicit cSettings(QObject *parent = 0);
    ~cSettings() {}// qDebug() << "Settings dying"; }

    qint32 paperWidth();
    void setPaperWidth(qint32 paperWidth);

    QString portNo();
    void setPortNo(QString portNo);

    QString port();
    void setPort(QString port);

    qint32 unit();
    void setUnit(qint32 unit);

    bool noteCashier();
    void setNoteCashier(bool noteCashier);

    QString notePredefined();
    void setNotePredefined(QString notePredefined);

private:
    qint32 _paperWidth;
    QString _portNo;
    QString _port;
    qint32 _unit;
    bool _noteCashier;
    QString _notePredefined;

signals:
     void settingsChanged();

};

Q_DECLARE_METATYPE(cSettings*)

#endif // SETTINGS_H
