#include <iomanip>
#include <sstream>
#include <cmath>
#include <QStringList>
#include "formatter.h"

QString Formatter::JustifyCenter(int width, QString str)
{
    int len = str.length();
    if (len > width)
    {
        str = str.mid(0, width);
        len = width;
    }
    int diff = width - len;
    int pad1 = diff/2;
    int pad2 = diff - pad1;
    return QString(pad1, ' ') + str + QString(pad2, ' ');
}

QString Formatter::JustifyRight(int width, QString str)
{
    int len = str.length();
    if (len > width)
    {
        str = str.mid(0, width);
        len = width;
    }
    int pad = width - len;
    return QString(pad, ' ') + str;
}

QString Formatter::BreakAndAlignStringLeft(int width, QString str)
{
    QStringList ret;
    int maxLines = 5;
    QStringList words = str.split(" ");

    QString singleLine = "";
    for(int i =0; i < words.length();)
    {
        if (singleLine.length() + words.at(i).length() <= width)
        {
            singleLine += words.at(i) + " ";
            i++;
        }
        else
        {
            if (words.at(i).length() > width)
            {
                int splitIndex = width - singleLine.length();
                if (splitIndex > 0)
                {
                    singleLine += words.at(i).mid(0, splitIndex);
                    QString rest = words.at(i).mid(splitIndex, words.at(i).length());
                    if (!rest.isEmpty())
                    {
                        words.insert(i + 1, rest);
                        i++;
                    }
                }
            }

            singleLine = singleLine.trimmed();
            ret.append(singleLine);
            singleLine = "";

            if (ret.length() == maxLines) break;
        }
    }

    if (!singleLine.isEmpty())
    {
        ret.append(singleLine);
    }

    QString final;
    for(int j = 0; j < ret.length(); j++)
    {
        final += ret.at(j) + "\n";
    }

    return final;
}

QString Formatter::GetPrikazDvijeDecimale(double value)
{
//    stringstream stream;
//    stream << fixed << setprecision(2) << number;
//    return stream.str();
    return QString::number(value, 'f', 2);
}

QString Formatter::GetKolicina(double value)
{
//    stringstream stream;
//    stream << fixed << setprecision(3) << amount;
//    return stream.str() + 'x';
    return QString::number(value, 'f', 3);
}

QString Formatter::GetRabat(double discount, double amount_with_discount)
{
    char sign;
    if (discount > 0)
    {
        sign = '-';
    }
    else
    {
        sign = '+';
    }
    discount = abs(discount);
    QString amount = GetPrikazDvijeDecimale(amount_with_discount);
    if ( amount.length() < 9)
    {
        return sign + GetPrikazDvijeDecimale(discount) + "%" +
                    QString(10 - amount.length(), ' ') +
                    amount;
    }
    else
    {
        return sign + GetPrikazDvijeDecimale(discount) + "% " +
                    amount;
    }
}

QString Formatter::GetPorez(double tax_rate)
{
    if (tax_rate < 0)
    {
        return "**,**%";
    }
    else
    {
        return GetPrikazDvijeDecimale(tax_rate) + "%";
    }
}

QString Formatter::NumberToString(int value)
{
//     stringstream stream;
//     stream << pNumber;
//     return stream.str();
     return QString::number(value);
}

QString Formatter::AlignStrings(int width, QString left, QString right)
{
    int numberOfBlankSpaces = width - (left.length() + right.length());
    if (numberOfBlankSpaces <= 0)
    {
        return left + "\n" + JustifyRight(width, right);
    }

    QString blankSpaces = QString(numberOfBlankSpaces, ' ');
    return left + blankSpaces + right;
}

QString Formatter::AlignStrings(int width, QString left, QString center, QString right)
{
    int numberOfBlankSpaces = width - (left.length() + center.length() + right.length());
    if (numberOfBlankSpaces > 0)
    {
        QString blankSpaces = QString(numberOfBlankSpaces / 2, ' ');
        if ((left + blankSpaces + center + blankSpaces + right).length() < width)
        {
            return left + blankSpaces + center + blankSpaces + " " + right;
        }
        else
        {
            return left + blankSpaces + center + blankSpaces + right;
        }
    }
    else
    {
        return AlignStrings(width, left, center) + "\n" + JustifyRight(width, right);
    }
}
