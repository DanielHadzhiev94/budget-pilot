#pragma once
#include <qobject.h>

class FinancialSummaryVm : public QObject {
    Q_OBJECT
    Q_PROPERTY(double current_balance READ current_balance NOTIFY current_balance_changed);

public:
    explicit FinancialSummaryVm(QObject *parent = nullptr, TransactionService);

    double current_balance() const;

    Q_INVOKABLE void add_income();

signals:
    void current_balance_changed();

private:
    double current_balance_ = 0.0;
};
