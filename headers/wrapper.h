#ifndef TWRAPPER_H
#define TWRAPPER_H

#include "headers/cCashier.h"
#include "headers/cDocument.h"
#include "headers/cCustomer.h"

int twrapper_receipt(cDocument* receipt, QList<QObject *> receiptItems, bool is_reclaim);
int twrapper_report(char type);
int twrapper_report_period(QDateTime from, QDateTime to);
int twrapper_duplicate(char type, QString number);
int twrapper_pay_in(char type, double amount);
int twrapper_pay_out(char type, double amount);
int twrapper_nonfiscal_text(QString text);

#endif


