#ifndef TRINGCOMMON_H
#define TRINGCOMMON_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QFileInfo>
#include <QtSql>

#include "headers/cCashier.h"
#include "headers/cItem.h"
#include "headers/cItemCommon.h"
#include "headers/cCustomer.h"
#include "headers/cCustomerCommon.h"
#include "headers/cGroup.h"
#include "headers/cGroupCommon.h"
#include "headers/cSettings.h"
#include "headers/cSettingsCommon.h"
#include "headers/cSubgroup.h"
#include "headers/cSubgroupCommon.h"
#include "headers/cTax.h"
#include "headers/cTaxCommon.h"
#include "headers/cDocument.h"
#include "headers/cDocumentCommon.h"
#include "headers/cDocumentItem.h"
#include "headers/cDocumentItemCommon.h"
#include "headers/cCashierCommon.h"

class cCommon : public QObject
{
    Q_OBJECT

public:
    cCommon();

    static cCashier *cashier;
    static cSettings *settings;
public slots:
    /* TFL */
    int tflReceipt(cDocument* receipt, QList<QObject*> receiptItems);
    int tflXReport();
    int tflZReport();
    int tflReceiptDuplicate(QString number);
    int tflReclaimReceiptDuplicate(QString number);
    int tflPeriodicalReport(QDateTime from, QDateTime to);
    int tflXReportDuplicate();
    int tflZReportDuplicate(QString number);
    int tflPeriodicalReportDuplicate();
    int tflReclaimReceipt(cDocument* receipt, QList<QObject*> receiptItems);
    int tflCashInOut(bool is_in, double amount);
    int tflCheckInOut(bool is_in, double amount);
    int tflCardInOut(bool is_in, double amount);
    int tflTransferInOut(bool is_in, double amount);
    int tflNonfiscalText(QString text);

    /* REPORTS */
    QString reportCashiersText(QDateTime from, QDateTime to);
    QString reportItemsText(QDateTime from, QDateTime to);
    QString reportGroupsText(QDateTime from, QDateTime to);
    QString reportSubgroupsText(QDateTime from, QDateTime to);
    QString reportCustomersText(QDateTime from, QDateTime to);
    QString reportStockPlus();
    QString reportStockMinus();

    /* INFO */
    QString getVersion();
    QString getGitCommit();

    /* BACKUP */
    QString dbPathFix(QString path);
    bool dbBackup(QString destinationPath);

    /* LOG */
    void logReceipt(cDocument *receipt, QList<QObject*> receiptItems);

};

#endif
