#ifndef TREPORTS_H
#define TREPORTS_H

QString report_cashiers_text(QDateTime from, QDateTime to);
QString report_items_text(QDateTime from, QDateTime to);
QString report_groups_text(QDateTime from, QDateTime to);
QString report_subgroups_text(QDateTime from, QDateTime to);
QString report_customers_text(QDateTime from, QDateTime to);

QString report_stock(bool check_only_positive);

#endif // TREPORTS_H

