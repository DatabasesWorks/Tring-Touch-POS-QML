#include "headers/cSettings.h"

cSettings::cSettings(QObject *parent) : QObject(parent)
{

}

qint32 cSettings::paperWidth()
{
    return _paperWidth;
}
void cSettings::setPaperWidth(qint32 paperWidth)
{
    _paperWidth = paperWidth;
}

QString cSettings::portNo()
{
    return _portNo;
}
void cSettings::setPortNo(QString portNo)
{
    _portNo = portNo;
}

QString cSettings::port()
{
    return _port;
}

void cSettings::setPort(QString port)
{
    _port = port;
}

qint32 cSettings::unit()
{
    return _unit;
}

void cSettings::setUnit(qint32 businessUnit)
{
    _unit = businessUnit;
}

bool cSettings::noteCashier()
{
    return _noteCashier;
}

void cSettings::setNoteCashier(bool noteCashier)
{
    _noteCashier = noteCashier;
}

QString cSettings::notePredefined()
{
    return _notePredefined;
}

void cSettings::setNotePredefined(QString notePredefined)
{
    _notePredefined = notePredefined;
}
