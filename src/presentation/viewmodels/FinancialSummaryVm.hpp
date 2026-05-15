#pragma once

#include <QObject>

namespace budgetpilot::application::services {
    class TransactionService;
    class AccountService;
}

namespace budgetpilot::domain::models {
    class Transaction;
}

namespace services = budgetpilot::application::services;

namespace budgetpilot::presentation::viewmodels {
    class FinancialSummaryVm final : public QObject {
        Q_OBJECT

        Q_PROPERTY(double current_balance READ current_balance NOTIFY current_balance_changed)
        Q_PROPERTY(double income READ income NOTIFY income_changed)
        Q_PROPERTY(double expense READ expense NOTIFY expense_changed)
        Q_PROPERTY(double saving_rate READ saving_rate NOTIFY saving_rate_changed)

    public:
        explicit FinancialSummaryVm(
            services::TransactionService &transaction_service,
            services::AccountService &account_service,
            QObject *parent = nullptr
        );

        [[nodiscard]]
        double current_balance() const;

        [[nodiscard]]
        double income() const;

        [[nodiscard]]
        double expense() const;

        [[nodiscard]]
        double saving_rate() const;

        Q_INVOKABLE void create_transaction(const domain::models::Transaction &transaction);
        Q_INVOKABLE void load_data(int month, int year);
        Q_INVOKABLE void set_date(int month, int year);

    signals:
        void current_balance_changed();
        void income_changed();
        void expense_changed();
        void saving_rate_changed();

    private:
        services::TransactionService &transaction_service_;
        services::AccountService &account_service_;

        int selected_month_;
        int selected_year_;

        double current_balance_{0.0};
        double income_{0.0};
        double expense_{0.0};
        double saving_rate_{0.0};

        void set_current_balance(double value);
        void set_income(double value);
        void set_expense(double value);
        void set_saving_rate(double value);

        void load_account_data();
        void load_income_data(int month, int year);
        void load_expense_data(int month, int year);
        void load_saving_rate(int month, int year);

        void reload_data();
    };
}
