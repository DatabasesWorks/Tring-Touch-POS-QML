#include "headers/bloks/Formatter.h"
#include "headers/cCommon.h"
#include "headers/wrapper.h"
#include "headers/bloks/Separator.h"
#include "headers/report.h"

#include <QtSql>
#include <QString>
#include <QObject>

QString report_cashier_line_format(QString name, QString total, QString report_lines)
{
    if (!report_lines.isEmpty())
    {
        report_lines += "\n";
        report_lines += Separator::GetReportSeparator(true);
    }

    report_lines += name + "\n";
    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("PROMET:"), total);

    return report_lines;
}

QString report_item_line_format(QString name, QString quantity, QString total, QString report_lines)
{
    if (!report_lines.isEmpty())
    {
        report_lines += "\n";
        report_lines += Separator::GetReportSeparator(true);
    }

    report_lines += name + "\n";
    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("KOLIČINA:"), quantity);

    report_lines += "\n";
    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("PROMET:"), total);

    return report_lines;
}

QString report_item_end_format(QString count, QString sum, QString report_lines)
{
    if (!report_lines.isEmpty())
    {
        report_lines += "\n";
        report_lines += Separator::GetReportSeparator(true);
    }

    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("SUMA:"), sum);

    report_lines += "\n";
    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("ARTIKLI:"), count);

    return report_lines;
}

QString report_stock_line_format(QString name, QString quantity, QString report_lines)
{
    if (!report_lines.isEmpty())
    {
        report_lines += "\n";
        report_lines += Separator::GetReportSeparator(true);
    }

    report_lines += name + "\n";
    report_lines += Formatter::AlignStrings(cCommon::settings->paperWidth(), QObject::tr("KOLIČINA:"), quantity);

    return report_lines;
}

QString report_with_date_period_format(QString title, QDateTime from, QDateTime to, QString report_lines)
{
    QString report;

    report += Formatter::JustifyCenter(cCommon::settings->paperWidth(), title) + "\n";

    QString s_from = from.toString("dd.MM.yyyy");
    report += Formatter::JustifyCenter(cCommon::settings->paperWidth(), QObject::tr("Od ") + s_from) + "\n";

    QString s_to = to.toString("dd.MM.yyyy");
    report += Formatter::JustifyCenter(cCommon::settings->paperWidth(), QObject::tr("Do ") + s_to) + "\n";

    report += "\n";

    report += report_lines;

    return report;
}


QString report_format(QString title, QString report_lines)
{
    QString report;

    report += Formatter::JustifyCenter(cCommon::settings->paperWidth(), title) + "\n";

    report += "\n";

    report += report_lines;

    return report;
}

QString report_cashiers_text(QDateTime from, QDateTime to)
{
    QString report = "";
    QString sQuery = "SELECT name, SUM(total) as total"
                         " FROM REPORT_CASHIER_VIEW"
                         " WHERE strftime('%d/%m/%Y', date)"
                         " BETWEEN strftime('%d/%m/%Y', :from)"
                         " AND strftime('%d/%m/%Y', :to)"
                         " GROUP BY cashier_id"
                         " ORDER BY name";
        QSqlQuery query;
        query.prepare(sQuery);
        query.bindValue( ":from", from );
        query.bindValue( ":to", to);
        if (!query.exec())
        {
            qDebug() << "> report_cashiers: " << query.lastError();
            return "";
        }

        QString report_lines;

        while(query.next())
        {
            QString name = query.value("name").toString();
            double total = query.value("total").toDouble();
            QString s_total = QLocale(QLocale::system()).toString(total, 'f', 2);
            report_lines = report_cashier_line_format(name, s_total, report_lines);
        }

        report = report_with_date_period_format("IZVJEŠTAJ KASIRA",
                                       from,
                                       to,
                                      report_lines);

        return report;
}

QString report_items_text(QDateTime from, QDateTime to)
{
    QString report = "";
    QString report_lines;

    QString sQuery = "SELECT SUM(quantity) as quantity, "
                     " SUM(total) as total, name"
                     " FROM  REPORT_ITEM_VIEW"
                     " WHERE strftime('%d/%m/%Y', date)"
                     " BETWEEN strftime('%d/%m/%Y', :from)"
                     " AND strftime('%d/%m/%Y', :to)"
                     " GROUP BY item_id"
                     " ORDER BY name";

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue( ":from", from );
    query.bindValue( ":to", to);

    if (!query.exec())
    {
        qDebug() << "> report_items_text: " << query.lastError();
        return "";
    }

    int counter = 0;
    double sum = 0;

    while(query.next())
    {
        QString name = query.value("name").toString();
        double quantity = query.value("quantity").toDouble();
        QString s_quantity = QLocale(QLocale::system()).toString(quantity, 'f', 3);
        double total = query.value("total").toDouble();
        QString s_total = QLocale(QLocale::system()).toString(total, 'f', 2);
        report_lines = report_item_line_format(name, s_quantity, s_total, report_lines);

        //count items
        counter++;
        //sum total of items
        sum += total;
    }

    if (counter != 0)
    {
        QString s_counter = QString::number(counter);
        QString s_sum = QLocale(QLocale::system()).toString(sum, 'f', 2);
        report_lines = report_item_end_format(s_counter, s_sum, report_lines);
    }

    report = report_with_date_period_format(QObject::tr("IZVJEŠTAJ PO ARTIKALIMA"),
                                   from,
                                   to,
                                  report_lines);

    return report;
}

QString report_groups_text(QDateTime from, QDateTime to)
{
    QString report = "";
    QString report_lines;

    QString sQuery = "SELECT name, SUM(quantity) as quantity,"
                     " SUM(total) as total"
                     " FROM REPORT_GROUP_VIEW"
                     " WHERE strftime('%d/%m/%Y', date)"
                     " BETWEEN strftime('%d/%m/%Y', :from)"
                     " AND strftime('%d/%m/%Y', :to)"
                     " GROUP BY group_id"
                     " ORDER BY name";

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue( ":from", from );
    query.bindValue( ":to", to);
    if (!query.exec())
    {
        qDebug() << "> report_groups_text: " << query.lastError();
        return "";
    }

    int counter = 0;
    double sum = 0;

    while(query.next())
    {
        QString name = query.value("name").toString();
        double quantity = query.value("quantity").toDouble();
        QString s_quantity = QLocale(QLocale::system()).toString(quantity, 'f', 3);
        double total = query.value("total").toDouble();
        QString s_total = QLocale(QLocale::system()).toString(total, 'f', 2);
        report_lines = report_item_line_format(name, s_quantity, s_total, report_lines);

        //count items
        counter++;
        //sum total of items
        sum += total;
    }

    if (counter != 0)
    {
        QString s_counter = QString::number(counter);
        QString s_sum = QLocale(QLocale::system()).toString(sum, 'f', 2);
        //report_lines = report_item_end_format(s_counter, s_sum, report_lines);
    }

    report = report_with_date_period_format(QObject::tr("IZVJEŠTAJ PO GRUPAMA"),
                                   from,
                                   to,
                                  report_lines);

    return report;
}

QString report_subgroups_text(QDateTime from, QDateTime to)
{
    QString report = "";
    QString report_lines;

    QString sQuery = "SELECT name, SUM(quantity) as quantity,"
                     " SUM(total) as total"
                     " FROM REPORT_SUBGROUP_VIEW"
                     " WHERE strftime('%d/%m/%Y', date)"
                     " BETWEEN strftime('%d/%m/%Y', :from)"
                     " AND strftime('%d/%m/%Y', :to)"
                     " GROUP BY subgroup_id"
                     " ORDER BY name";

    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue( ":from", from );
    query.bindValue( ":to", to);
    if (!query.exec())
    {
        qDebug() << "> report_subgroups_text: " << query.lastError();
        return "";
    }

    int counter = 0;
    double sum = 0;

    while(query.next())
    {
        QString name = query.value("name").toString();
        double quantity = query.value("quantity").toDouble();
        QString s_quantity = QLocale(QLocale::system()).toString(quantity, 'f', 3);
        double total = query.value("total").toDouble();
        QString s_total = QLocale(QLocale::system()).toString(total, 'f', 2);
        report_lines = report_item_line_format(name, s_quantity, s_total, report_lines);

        //count items
        counter++;
        //sum total of items
        sum += total;
    }

    if (counter != 0)
    {
        QString s_counter = QString::number(counter);
        QString s_sum = QLocale(QLocale::system()).toString(sum, 'f', 2);
        //report_lines = report_item_end_format(s_counter, s_sum, report_lines);
    }

    report = report_with_date_period_format(QObject::tr("IZVJEŠTAJ PO PODGRUPAMA"),
                                   from,
                                   to,
                                  report_lines);

    return report;
}

QString report_customers_text(QDateTime from, QDateTime to)
{
    QString report = "";
    QString sQuery = "SELECT customer_id, line_1, SUM(total) as total"
                     " FROM REPORT_CUSTOMER_VIEW"
                     " WHERE strftime('%d/%m/%Y', date)"
                     " BETWEEN strftime('%d/%m/%Y', :from)"
                     " AND strftime('%d/%m/%Y', :to)"
                     " GROUP BY customer_id"
                     " ORDER BY line_1";
    QSqlQuery query;
    query.prepare(sQuery);
    query.bindValue( ":from", from );
    query.bindValue( ":to", to);
    if (!query.exec())
    {
        qDebug() << "> report_customers_text: " << query.lastError();
        return "";
    }

    QString report_lines;

    while(query.next())
    {
        QString name = query.value("line_1").toString();
        int customer_id = query.value("customer_id").toInt();
        QString s_name = (customer_id != 0) ? name : "Fizička lica";
        double total = query.value("total").toDouble();
        QString s_total = QLocale(QLocale::system()).toString(total, 'f', 2);
        report_lines = report_cashier_line_format(s_name, s_total, report_lines);
    }

    report = report_with_date_period_format(QObject::tr("IZVJEŠTAJ PO KUPCIMA"),
                                   from,
                                   to,
                                   report_lines);
    return report;
}

QString report_stock(bool check_only_positive)
{
    QString report = "";

    QString sQuery = "SELECT name, current_quantity from STOCK_VIEW";
    if (check_only_positive)
    {
        sQuery += " WHERE current_quantity > 0";
    }
    else
    {
        sQuery += " WHERE current_quantity <= 0";
    }

    QSqlQuery query;
    query.prepare(sQuery);
    if (!query.exec())
    {
        qDebug() << "> report_stock: " << query.lastError();
        return "";
    }

    QString report_lines;

    while(query.next())
    {
        QString name = query.value("name").toString();
        double current_quantity = query.value("current_quantity").toDouble();
        QString s_quantity = QLocale(QLocale::system()).toString(current_quantity, 'f', 3);
        report_lines = report_stock_line_format(name, s_quantity, report_lines);
    }

    report = report_format(QObject::tr("LAGER"), report_lines);

    return report;

}
