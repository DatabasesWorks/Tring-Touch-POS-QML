#include "headers/cItem.h"
#include "headers/cCashier.h"
#include "headers/cGroup.h"
#include "headers/cSubgroup.h"
#include "headers/cTax.h"
#include "headers/cSettings.h"
#include "headers/cSettingsCommon.h"
#include "headers/cTaxCommon.h"
#include "headers/wrapper.h"
#include "headers/cCommon.h"
#include "headers/codePage.h"
#include "headers/report.h"
#include "headers/bloks/separator.h"
#include "headers/cConnection.h"
#include "headers/cDocumentItem.h"
#include "headers/cCashier.h"

#include <QDebug>

using namespace std;

cCashier *cCommon::cashier = new cCashier();
cSettings *cCommon::settings = new cSettings();

cCommon::cCommon()
{

}

static int handleError(QString function, int err)
{
    if (0 != err)
        qDebug() << function << ":" << QString::number(err);

    return err;
}

int cCommon::tflReceipt(cDocument* receipt, QList<QObject*> receiptItems)
{
    int err = twrapper_receipt(receipt, receiptItems, false);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflXReport()
{
    int err = twrapper_report('2');
    return handleError(__FUNCTION__, err);
}

int cCommon::tflZReport()
{
    int err = twrapper_report('0');
    return handleError(__FUNCTION__, err);
}

int cCommon::tflReceiptDuplicate(QString number)
{
    int err = twrapper_duplicate('F', number);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflReclaimReceiptDuplicate(QString number)
{
    int err = twrapper_duplicate('R', number);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflPeriodicalReport(QDateTime from, QDateTime to)
{
    int err = twrapper_report_period(from, to);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflXReportDuplicate()
{
    int err = twrapper_duplicate('X', "0");
    return handleError(__FUNCTION__, err);
}

int cCommon::tflZReportDuplicate(QString number)
{
    int err = twrapper_duplicate('Z', number);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflPeriodicalReportDuplicate()
{
    int err = twrapper_duplicate('P', "0");
    return handleError(__FUNCTION__, err);
}

int cCommon::tflReclaimReceipt(cDocument* receipt, QList<QObject*> receiptItems)
{
    int err = twrapper_receipt(receipt, receiptItems, true);
    return handleError(__FUNCTION__, err);
}

int cCommon::tflCashInOut(bool is_in, double amount)
{
    int err = 0;

    if (is_in)
        err = twrapper_pay_in(0, amount);
    else
        err = twrapper_pay_out(0, amount);

    return handleError(__FUNCTION__, err);
}

int cCommon::tflCheckInOut(bool is_in, double amount)
{
    int err = 0;

    if (is_in)
        err = twrapper_pay_in(1, amount);
    else
        err = twrapper_pay_out(1, amount);

    return handleError(__FUNCTION__, err);
}

int cCommon::tflCardInOut(bool is_in, double amount)
{
    int err = 0;

    if (is_in)
        err = twrapper_pay_in(2, amount);
    else
        err = twrapper_pay_out(2, amount);

    return handleError(__FUNCTION__, err);
}

int cCommon::tflTransferInOut(bool is_in, double amount)
{
    int err = 0;

    if (is_in)
        err = twrapper_pay_in(3, amount);
    else
        err = twrapper_pay_out(3, amount);

    return handleError(__FUNCTION__, err);
}

int cCommon::tflNonfiscalText(QString text)
{
    int err = twrapper_nonfiscal_text(text);
    return handleError(__FUNCTION__, err);
}

QString cCommon::reportCashiersText(QDateTime from, QDateTime to)
{
    return report_cashiers_text(from, to);
}

QString cCommon::reportItemsText(QDateTime from, QDateTime to)
{
    return report_items_text(from, to);
}

QString cCommon::reportGroupsText(QDateTime from, QDateTime to)
{
    return report_groups_text(from, to);
}

QString cCommon::reportSubgroupsText(QDateTime from, QDateTime to)
{
    return report_subgroups_text(from, to);
}

QString cCommon::reportCustomersText(QDateTime from, QDateTime to)
{
    return report_customers_text(from, to);
}

QString cCommon::reportStockPlus()
{
    return report_stock(true);
}

QString cCommon::reportStockMinus()
{
    return report_stock(false);
}

QString cCommon::getVersion()
{
    QString version(VERSION_STRING);
    return version;
}

QString cCommon::getGitCommit()
{
    QString git_commit(GIT_CURRENT_SHA1);
    int indx = git_commit.indexOf("-g");
    return git_commit.mid(indx+2, git_commit.length());
    return git_commit;
}

QString cCommon::dbPathFix(QString path)
{
    if (path.startsWith("file://"))
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
        path = path.remove("file:///");
#else
        path = path.remove("file://");
#endif

    return path;
}

bool cCommon::dbBackup(QString destinationPath)
{
//    cConnection connection;
//    QString source = connection.getDatabaseFullPath();

//      QString destination = destinationPath + "/TringTouchPOS_backup.sqlite";
//      qDebug()<<"Cp from :" << source << " to : "<< destination;
//      QFile file(source);
//      if (QFile::exists(destinationPath))
//           QFile::remove(destinationPath);

//      qDebug()<<file.copy(destination);
//      qDebug()<<file.errorString();

//      return false;

    cConnection connection;
    QString fromPath = connection.getDatabaseFullPath();

    destinationPath += "/TringTouchPOS_backup.sqlite";

    qDebug() << "from: " << fromPath;
    qDebug() << "to: " << destinationPath;

    if (QFile::exists(destinationPath))
            QFile::remove(destinationPath);

    bool copied = QFile::copy(fromPath, destinationPath);

    if(copied)
        qDebug() << "success";
    else
        qDebug() << "failed";

    return copied;
}

void cCommon::logReceipt(cDocument *receipt, QList<QObject *> receiptItems)
{
//    foreach (QObject* o, receiptItems)
//    {
//           cReceiptItem* p = dynamic_cast<cReceiptItem*>(o);

//           qDebug() << "=======================================";
//           qDebug() << "receipt_id: " << p->receiptId();
//           qDebug() << "item_id: " << p->itemId() << "\n";
//           qDebug() << "quantity: " << p->quantity() << "\n";
//           qDebug() << "discount_p: " << p->discountP() << "\n";
//           qDebug() << "discount: " << p->discount() << "\n";
//           qDebug() << "tax_id: " << p->taxId() << "\n";
//           qDebug() << "tax: " << p->tax();
//           qDebug() << "---------------------------------------\n";
//    }
//    qDebug() << "receipt_id: " << receipt->id() << "\n";
//    qDebug() << "title: " << receipt->title() << "\n";
//    qDebug() << "customer_id: " << receipt->customerId() << "\n";
//    qDebug() << "card: " << receipt->card() << "\n";
//    qDebug() << "cash: " << receipt->cash() << "\n";
//    qDebug() << "check: " << receipt->check() << "\n";
//    qDebug() << "transfer_order: " << receipt->transferOrder() << "\n";
//    qDebug() << "fiscal_number: " << receipt->fiscalNumber() << "\n";
//    qDebug() << "reclaimed_number: " << receipt->reclaimedNumber() << "\n";
//    qDebug() << "total: " << receipt->total() << "\n";
//    qDebug() << "note: " << receipt->note() << "\n";
//    qDebug() << "unit_id: " << receipt->unitId() << "\n";
//    qDebug() << "=======================================\n";
}
