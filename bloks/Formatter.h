#ifndef FORMATTER_H
#define FORMATTER_H

#include <QString>

class Formatter{
public:
    static QString JustifyCenter(int width, QString str);
    static QString GetPrikazDvijeDecimale(double value);
    static QString GetKolicina(double value);
    static QString GetRabat(double discount, double amount_with_discount);
    static QString GetPorez(double tax_rate);
    static QString NumberToString(int value);
    static QString AlignStrings(int width, QString left, QString right);
    static QString AlignStrings(int width, QString left, QString center, QString right);
    static QString JustifyRight(int width, QString str);
    static QString BreakAndAlignStringLeft(int width, QString str);
};

#endif // FORMATTER_H
