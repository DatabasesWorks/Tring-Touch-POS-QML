extern "C" {
#include "tring_fiscal_library.h"
}
#include "headers/cDocumentItem.h"
#include "headers/cDocumentItemCommon.h"
#include "headers/cItem.h"
#include "headers/cItemCommon.h"
#include "headers/cSqlCommon.h"
#include "headers/cCommon.h"
#include "headers/wrapper.h"
#include "headers/codePage.h"
#include "headers/conversion.h"
#include "headers/cCustomerCommon.h"

#include <QString>

tfl_DATETIME convert_qdatetime_to_tfldatetime(QDateTime dt)
{
    tfl_DATETIME tfl_dt;
    tfl_dt.day = dt.date().day();
    tfl_dt.month = dt.date().month();
    int year = dt.date().year() / 1000;
    tfl_dt.year = dt.date().year() - (year * 1000);
    tfl_dt.hour = dt.time().hour();
    tfl_dt.minute = dt.time().minute();
    tfl_dt.second = dt.time().second();
    return tfl_dt;
}

int twrapper_receipt(cDocument* receipt, QList<QObject *> receipt_items, bool is_reclaim)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());
    uint8_t *t_iosa = {0};

    tfl_CASHIER *pt_cashier;
    tfl_CASHIER t_cashier;
    t_cashier.id = cCommon::cashier->id();
    char *t_name = getCodePageCharsFromUnicode(cCommon::cashier->name());
    strncpy((char *)t_cashier.name, (char *)t_name, sizeof(t_cashier.name));
    pt_cashier = &t_cashier;

    uint32_t t_reclaim = 0;
    if (is_reclaim)
    {
        t_reclaim = receipt->fiscalNumber();
    }

    uint16_t t_receipt_items_count = receipt_items.length();

    tfl_RECEIPT_ITEM t_receipt_items[t_receipt_items_count];
    memset(t_receipt_items, 0, t_receipt_items_count * sizeof(tfl_RECEIPT_ITEM));

    for( int i = 0; i < t_receipt_items_count; i++ )
    {
        cDocumentItem *rec_item = qobject_cast<cDocumentItem*>(receipt_items.at(i));

        if(rec_item)
        {
            cItemCommon *itemCommon = new cItemCommon();
            cItem *item = itemCommon->getItem(rec_item->itemId());

            char *t_barcode = getCodePageCharsFromUnicode(item->barcode());
            strncpy((char *)t_receipt_items[i].item.barcode, (char *)t_barcode, sizeof(t_receipt_items[i].item.barcode));

            char *t_name = getCodePageCharsFromUnicode(item->name());
            strncpy((char *)t_receipt_items[i].item.name, (char *)t_name, sizeof(t_receipt_items[i].item.name));

            t_receipt_items[i].item.plu = (uint16_t)item->id();
            t_receipt_items[i].item.price = convert_double_to_uint(rec_item->priceWithTax(), 2);
            t_receipt_items[i].item.tax = (tfl_TAX_RATE)rec_item->taxId();
            t_receipt_items[i].quantity = (uint32_t)(rec_item->output() * 1000);
            t_receipt_items[i].discount = (int16_t)(rec_item->discountP() * 100);
        }
    }

    tfl_PAYMENTS t_payments[4];
    memset(t_payments, 0, 4 * sizeof(tfl_PAYMENTS));

    uint8_t t_payment_count = 0;
    if (receipt->cash() >= 0)
    {
       t_payments[t_payment_count].type = PAYMENT_TYPES_CASH;
       t_payments[t_payment_count].amount = convert_double_to_uint(receipt->cash(), 2);
       t_payment_count++;
    }
    if (receipt->card() >= 0)
    {
       t_payments[t_payment_count].type = PAYMENT_TYPES_CARD;
       t_payments[t_payment_count].amount = convert_double_to_uint(receipt->card(), 2);
       t_payment_count++;
    }
    if (receipt->check() >= 0)
    {
       t_payments[t_payment_count].type = PAYMENT_TYPES_CHECK;
       t_payments[t_payment_count].amount = convert_double_to_uint(receipt->check(), 2);
       t_payment_count++;
    }
    if (receipt->transferOrder() >= 0)
    {
       t_payments[t_payment_count].type = PAYMENT_TYPES_TRANSFER_ORDER;
       t_payments[t_payment_count].amount = convert_double_to_uint(receipt->transferOrder(), 2);
       t_payment_count++;
    }

    tfl_CUSTOMER *pt_customer;
    cCustomerCommon *customerCommon = new cCustomerCommon();
    cCustomer *customer = customerCommon->getCustomer(receipt->customerId());

    if (receipt->customerId() > 0)
    {
        tfl_CUSTOMER t_customer;
        char *t_ibk = getCodePageCharsFromUnicode(customer->idc());
        strncpy((char *)t_customer.ibk, (char *)t_ibk, sizeof(t_customer.ibk));

        char *t_line1 = getCodePageCharsFromUnicode(customer->line1());
        strncpy((char *)t_customer.line1, (char *)t_line1, sizeof(t_customer.line1));

        char *t_line2 = getCodePageCharsFromUnicode(customer->line2());
        strncpy((char *)t_customer.line2, (char *)t_line2, sizeof(t_customer.line2));

        char *t_line3 = getCodePageCharsFromUnicode(customer->line3());
        strncpy((char *)t_customer.line3, (char *)t_line3, sizeof(t_customer.line3));

        char *t_line4 = getCodePageCharsFromUnicode(customer->line4());
        strncpy((char *)t_customer.line4, (char *)t_line4, sizeof(t_customer.line4));

        pt_customer = &t_customer;
    }
    else
    {
        pt_customer = 0;
    }

    uint8_t *t_note = (uint8_t *)getCodePageCharsFromUnicode(receipt->note());

    tfl_RESPONSE_RECEIPT t_response;
    ERROR_CODE err = tfl_receipt(t_comport, t_iosa, pt_cashier, t_reclaim,
                t_receipt_items, t_receipt_items_count,
                t_payments, t_payment_count, pt_customer,
                t_note, &t_response);

    if (0 == err)
    {
        //set fiscal/reclaim number
        if (is_reclaim)
        {
            receipt->setReclaimedNumber(t_response.reclaimed_receipt_number);
        }
        else
        {
            receipt->setFiscalNumber(t_response.fiscal_receipt_number);
        }

        receipt->setTotal(convert_uint_to_double(t_response.receipt_total, 2));
    }

    return (int)err;

}

int twrapper_report(char type)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());

    tfl_RESPONSE_REPORT t_response;
    ERROR_CODE err = tfl_report(t_comport, (tfl_REPORT_TYPES)type, &t_response);

    return (int)err;
}

int twrapper_report_period(QDateTime from, QDateTime to)
{
     uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());

     tfl_DATETIME t_from = convert_qdatetime_to_tfldatetime(from);
     tfl_DATETIME t_to = convert_qdatetime_to_tfldatetime(to);
     ERROR_CODE err = tfl_report_period(t_comport, &t_from, &t_to);

     return (int)err;
}

int twrapper_duplicate(char type, QString number)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());
    uint t_number = number.toUInt();

    tfl_RESPONSE_DUPLICATE t_response;
    ERROR_CODE err = tfl_duplicate(t_comport, (tfl_DUPLICATE_TYPES)type, (uint32_t)t_number, &t_response);

    return (int)err;
}

int twrapper_pay_in(char type, double amount)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());
    uint t_amount = convert_double_to_uint(amount, 2);

    tfl_RESPONSE_CASH t_response;
    ERROR_CODE err = tfl_pay_in(t_comport, (tfl_PAYMENT_TYPES)type, (uint32_t)t_amount, &t_response);

    return (int)err;
}

int twrapper_pay_out(char type, double amount)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());
    uint t_amount = convert_double_to_uint(amount, 2);

    tfl_RESPONSE_CASH t_response;
    ERROR_CODE err = tfl_pay_out(t_comport, (tfl_PAYMENT_TYPES)type, (uint32_t)t_amount, &t_response);

    return (int)err;
}

int twrapper_nonfiscal_text(QString text)
{
    uint8_t *t_comport = (uint8_t *)getCodePageCharsFromUnicode(cCommon::settings->port());
    uint8_t *t_text = (uint8_t *)getCodePageCharsFromUnicode(text);

    ERROR_CODE err = tfl_nonfiscal_text(t_comport, t_text);
    return (int)err;
}
