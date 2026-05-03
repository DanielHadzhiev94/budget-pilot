#pragma once
#include <qobject.h>

namespace budgetpilot {
    namespace application::transaction {
        class TransactionService;
    }

    namespace presentation::viewmodels {
        class FinancialSummaryVm : public QObject {
            Q_OBJECT

            Q_PROPERTY(double current_balance READ current_balance NOTIFY current_balance_changed);
            Q_PROPERTY(double income READ income NOTIFY income_changed);
            Q_PROPERTY(double expense READ expense NOTIFY expense_changed);

        public:
            explicit FinancialSummaryVm(application::transaction::TransactionService *transaction_service,
                                        QObject *parent = nullptr);

            [[nodiscard]] double current_balance() const;
            [[nodiscard]] double income() const;
            [[nodiscard]] double expense() const;

            Q_INVOKABLE void add_income();
            Q_INVOKABLE void load_data(int month, int year);

        signals:
            void current_balance_changed();
            void income_changed();
            void expense_changed();

        private:
            application::transaction::TransactionService *transaction_service_;

            double current_balance_ = 0.0;
            double income_ = 0.0;
            double expense_ = 0.0;

            void set_current_balance();
            void set_income();
            void set_expense();
        };
    }
}
