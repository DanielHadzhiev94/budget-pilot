#pragma once

#include <QObject>

namespace budgetpilot::application::services {
    class TransactionService;
    class AccountService;
}

namespace budgetpilot::domain::models {
    class Transaction;
}

namespace budgetpilot::presentation::viewmodels {
    class FinancialSummaryVm final : public QObject {
        Q_OBJECT

        Q_PROPERTY(double current_balance READ current_balance NOTIFY current_balance_changed)
        Q_PROPERTY(double income READ income NOTIFY income_changed)
        Q_PROPERTY(double expense READ expense NOTIFY expense_changed)

    public:
        explicit FinancialSummaryVm(
            application::services::TransactionService &transaction_service,
            application::services::AccountService &account_service,
            QObject *parent = nullptr
        );

        [[nodiscard]]
        double current_balance() const;

        [[nodiscard]]
        double income() const;

        [[nodiscard]]
        double expense() const;

        Q_INVOKABLE void create_transaction(const domain::models::Transaction &transaction);
        Q_INVOKABLE void load_data(int month, int year);

    signals:
        void current_balance_changed();
        void income_changed();
        void expense_changed();

    private:
        application::services::TransactionService &transaction_service_;
        application::services::AccountService &account_service_;

        double current_balance_{0.0};
        double income_{0.0};
        double expense_{0.0};

        void set_current_balance(double value);
        void set_income(double value);
        void set_expense(double value);
        void reload_data();
    };
}
