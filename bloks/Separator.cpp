#include "cCommon.h"
#include "separator.h"

QString Separator::GetDocumentSeparator(bool withNewLine)
{
    QString str = QString(cCommon::settings->paperWidth(), '=');

    if (withNewLine)
    {
        str += "\n";
    }

    return str;
}

QString Separator::GetBlockSeparator(bool withNewLine)
{
    QString str = QString(cCommon::settings->paperWidth(), '-');

    if (withNewLine)
    {
        str += "\n";
    }

    return str;
}

QString Separator::GetReportSeparator(bool withNewLine)
{
    QString str = QString(cCommon::settings->paperWidth(), '.');

    if (withNewLine)
    {
        str += "\n";
    }

    return str;
}
