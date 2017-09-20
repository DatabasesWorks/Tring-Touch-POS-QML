#ifndef TRING_FISCAL_LIBRARY_H_
#define TRING_FISCAL_LIBRARY_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>
#include "error_codes.h"

#define T_PAPER_WIDTH_MAX		48
#define T_ITEM_NAME_LENGTH 		(2 * T_PAPER_WIDTH_MAX)

typedef enum
{
	TAX_RATE_A = 1,
	TAX_RATE_E = 2,
	TAX_RATE_J = 3,
	TAX_RATE_K = 4,
	TAX_RATE_M = 5
} tfl_TAX_RATE;

typedef enum
{
	PAYMENT_TYPES_CASH,
	PAYMENT_TYPES_CHECK,
	PAYMENT_TYPES_CARD,
	PAYMENT_TYPES_TRANSFER_ORDER,
	PAYMENT_TYPES_NULL
} tfl_PAYMENT_TYPES;

typedef enum
{
	FISCAL_DOCUMENT_Z_REPORT = '0',
	FISCAL_DOCUMENT_X_REPORT = '2'
} tfl_REPORT_TYPES;

typedef enum
{
	FISCAL_DOCUMENT_DUPLICATE_RECEIPT = 			'F',
	FISCAL_DOCUMENT_DUPLICATE_RECLAIM_RECEIPT = 	'R',
	FISCAL_DOCUMENT_DUPLICATE_X_REPORT = 			'X',
	FISCAL_DOCUMENT_DUPLICATE_Z_REPORT = 			'Z',
	FISCAL_DOCUMENT_DUPLICATE_PERIODICAL_REPORT = 	'P'
} tfl_DUPLICATE_TYPES;

typedef enum
{
      SERVICE_TYPE_N = 'N',
      SERVICE_TYPE_T = 'T',
      SERVICE_TYPE_B = 'B',
      SERVICE_TYPE_P = 'P',
      SERVICE_TYPE_F = 'F',
      SERVICE_TYPE_O = 'O',
      SERVICE_TYPE_K = 'K',
      SERVICE_TYPE_M = 'M',
      SERVICE_TYPE_I = 'I',
} tfl_SERVICE_TYPE;

typedef struct
{
	/* seconds (0 - 59) */
	uint8_t second;
	/* minutes (0 - 59) */
	uint8_t minute;
	/* hours (0 - 23) */
	uint8_t hour;
	/* day of week (0-Sunday, ..., 6-Saturday) */
	uint8_t day_of_week;
	/* day (1 - 31) */
	uint8_t day;
	/* month (1 - 12) */
	uint8_t month;
	/* year */
	uint8_t year;
} tfl_DATETIME;

typedef struct
{
	uint8_t name[T_ITEM_NAME_LENGTH + 1];
	/* barcode (ean 13) */
	uint8_t barcode[14];
	uint32_t price;
	tfl_TAX_RATE tax;
	uint16_t plu;
} tfl_ITEM;

typedef struct
{
	/* client ID (ean 13) */
	uint8_t ibk[14];
	uint8_t line1[T_PAPER_WIDTH_MAX + 1];
	uint8_t line2[T_PAPER_WIDTH_MAX + 1];
	uint8_t line3[T_PAPER_WIDTH_MAX + 1];
	uint8_t line4[T_PAPER_WIDTH_MAX + 1];
} tfl_CUSTOMER;

typedef struct
{
	uint8_t id;
	uint8_t name[26];
	uint8_t password[7];
} tfl_CASHIER;

typedef struct
{
	tfl_ITEM item;
	uint32_t quantity;
	int16_t discount;
	bool canceled;
} tfl_RECEIPT_ITEM;

typedef struct
{
	tfl_PAYMENT_TYPES type;
	uint32_t amount;
} tfl_PAYMENTS;

typedef struct
{
    tfl_SERVICE_TYPE service_type;
    tfl_DATETIME start_datetime;
    tfl_DATETIME end_datetime;
} tfl_FM_SERVICE;

typedef struct
{
	tfl_DATETIME current_datetime;
	uint8_t ibfm[7];

	uint32_t first_BF;
	uint32_t last_BF;
	uint32_t first_RF;
	uint32_t last_RF;

	uint32_t cash;
	uint32_t check;
	uint32_t card;
	uint32_t transfer_order;
	uint16_t z_number;

	uint8_t services;
	uint8_t resets;
	uint8_t tax_changes;

    /*registered sale*/
    uint32_t sale_TA;
    uint32_t sale_TE;
    uint32_t sale_TJ;
    uint32_t sale_TK;
    uint32_t sale_TM;
    /*registered sale tax rates*/
    uint32_t sale_ZA;
    uint32_t sale_ZE;
    uint32_t sale_ZJ;
    uint32_t sale_ZK;
    uint32_t sale_ZM;
    /*canceled registered sales*/
    uint32_t canceled_sale_SEA;
    uint32_t canceled_sale_EA;
    uint32_t canceled_sale_SEP;
    /*reclaimed sale*/
    uint32_t reclaimed_sale_AT;
    uint32_t reclaimed_sale_ET;
    uint32_t reclaimed_sale_JT;
    uint32_t reclaimed_sale_KT;
    uint32_t reclaimed_sale_MT;
    /*reclaimed sale tax rates*/
    uint32_t reclaimed_sale_AZ;
    uint32_t reclaimed_sale_EZ;
    uint32_t reclaimed_sale_JZ;
    uint32_t reclaimed_sale_KZ;
    uint32_t reclaimed_sale_MZ;
    /*canceled reclaimed sale*/
    uint32_t canceled_reclaimed_sale_SRA;
    uint32_t canceled_reclaimed_sale_RA;
    uint32_t canceled_reclaimed_sale_SRP;

    /*current tax rates*/
    int16_t tax_a;
    int16_t tax_e;
    int16_t tax_j;
    int16_t tax_k;
    int16_t tax_m;
} tfl_DEVICE_STATUS;

typedef struct
{
	/*total number of fiscal receipts*/
	uint32_t total_receipt_number;
	/*fiscal receipt number*/
	uint32_t fiscal_receipt_number;
	/*reclaimed receipt number*/
	uint32_t reclaimed_receipt_number;
	/*fiscal date*/
	tfl_DATETIME fiscal_date;
	/*receipt total*/
	uint32_t receipt_total;
} tfl_RESPONSE_RECEIPT;

typedef struct
{
	uint16_t closure;
	uint32_t invoice_tax_a;
	uint32_t invoice_tax_e;
	uint32_t invoice_tax_j;
	uint32_t invoice_tax_k;
	uint32_t invoice_tax_m;
	uint32_t reclaimed_tax_a;
	uint32_t reclaimed_tax_e;
	uint32_t reclaimed_tax_j;
	uint32_t reclaimed_tax_k;
	uint32_t reclaimed_tax_m;
} tfl_RESPONSE_REPORT;

typedef struct
{
	uint8_t duplicate_count;
} tfl_RESPONSE_DUPLICATE;

typedef struct
{
	uint8_t exit_code;
	uint32_t cash_sum;
	uint32_t serv_in;
	uint32_t serv_out;
} tfl_RESPONSE_CASH;

ERROR_CODE tfl_is_alive(uint8_t *comport);

ERROR_CODE tfl_receipt(uint8_t *comport, uint8_t *iosa, tfl_CASHIER *cashier, uint32_t reclaimed,
					   tfl_RECEIPT_ITEM receipt_items[], uint16_t receipt_items_count,
					   tfl_PAYMENTS payments[], uint16_t payments_count,
					   tfl_CUSTOMER *customer, uint8_t *note, tfl_RESPONSE_RECEIPT *response);
ERROR_CODE tfl_receipt_ics(uint8_t *comport, uint8_t *iosa, tfl_CASHIER *cashier, uint32_t reclaimed,
					   tfl_RECEIPT_ITEM receipt_items[], uint16_t receipt_items_count,
					   tfl_PAYMENTS payments[], uint16_t payments_count,
					   tfl_CUSTOMER *customer, uint8_t *note, tfl_RESPONSE_RECEIPT *response);
ERROR_CODE tfl_receipt_cancel(uint8_t *comport);

ERROR_CODE tfl_report(uint8_t *comport, tfl_REPORT_TYPES type, tfl_RESPONSE_REPORT *response);
ERROR_CODE tfl_report_period(uint8_t *comport, tfl_DATETIME *from, tfl_DATETIME *to);
ERROR_CODE tfl_duplicate(uint8_t *comport, tfl_DUPLICATE_TYPES type, uint32_t document_number, tfl_RESPONSE_DUPLICATE *response);

ERROR_CODE tfl_nonfiscal_text(uint8_t *comport, uint8_t *text);

ERROR_CODE tfl_item_write(uint8_t *comport, tfl_ITEM *item);
ERROR_CODE tfl_item_read(uint8_t *comport, uint16_t plu, tfl_ITEM *item);
ERROR_CODE tfl_item_delete(uint8_t *comport, uint16_t plu);

ERROR_CODE tfl_cash_in(uint8_t *comport, uint32_t amount, tfl_RESPONSE_CASH *response);
ERROR_CODE tfl_cash_out(uint8_t *comport, uint32_t amount, tfl_RESPONSE_CASH *response);
ERROR_CODE tfl_pay_in(uint8_t *comport, tfl_PAYMENT_TYPES type, uint32_t amount, tfl_RESPONSE_CASH *response);
ERROR_CODE tfl_pay_out(uint8_t *comport, tfl_PAYMENT_TYPES type, uint32_t amount, tfl_RESPONSE_CASH *response);

ERROR_CODE tfl_display_show(uint8_t *comport, uint8_t *line1, uint8_t *line2);
ERROR_CODE tfl_open_drawer(uint8_t *comport);

ERROR_CODE tfl_fiscal_service(uint8_t *comport, tfl_SERVICE_TYPE type, tfl_FM_SERVICE *service);
ERROR_CODE tfl_device_status(uint8_t *comport, tfl_DEVICE_STATUS *device_status);

#ifdef __cplusplus
}
#endif

#endif /* TRING_FISCAL_LIBRARY_H_ */
