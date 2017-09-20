#ifndef SEPARATOR_H
#define SEPARATOR_H

#include <QString>

class Separator{
public:
    static QString GetDocumentSeparator(bool withNewLine);
    static QString GetBlockSeparator(bool withNewLine);
    static QString GetReportSeparator(bool withNewLine);
};

#endif // SEPARATOR_H
