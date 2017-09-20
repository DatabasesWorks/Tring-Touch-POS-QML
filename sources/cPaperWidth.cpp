#include "headers/cPaperWidth.h"

#include <QList>
#include <QObject>

cPaperWidth::cPaperWidth(QObject *parent)  : QObject(parent)
{

}

cPaperWidth::cPaperWidth(const QString &naziv, qint32 vrijednost, QObject *parent)
    : QObject(parent), _name(naziv), _value(vrijednost)
{
}

QString cPaperWidth::name() const
{
    return _name;
}

void cPaperWidth::setName(const QString &name)
{
    if (name != _name) {
        _name = name;
        emit nameChanged();
    }
}

qint32 cPaperWidth::value()
{
    return _value;
}

void cPaperWidth::setValue(qint32 value)
{
    if (value != _value) {
        _value = value;
        emit valueChanged();
    }
}
