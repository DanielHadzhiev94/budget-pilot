#pragma once

#include <QObject>

#include "src/domain/models/Transaction.hpp"
#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::models {
    class Account;
}

namespace budgetpilot::domain::contracts {
    class ITransactionRepository;

    template<typename T>
    class IRepository;
}

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services {
    class TransactionService : public QObject {
        Q_OBJECT

    public:
        explicit TransactionService(contracts::IRepository<models::Account> &account_repository,
                                    contracts::ITransactionRepository &transaction_repository
        );

        [[nodiscard]]
        utilities::Response<void> create_transaction(const models::Transaction &transaction);

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction> > load_all_by_month(const int month, const int year);
        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction> > load_income(
            const int month, const int year) const;

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction> > load_expense(
            const int month, const int year) const;

        [[nodiscard]]
        utilities::Response<double> calculate_monthly_saving_rate(int month, int year);

        utilities::Response<void> delete_transaction(const std::uint64_t id);

    signals:
        void transaction_changed();

    private:
        contracts::IRepository<models::Account> &account_repository_;
        contracts::ITransactionRepository &transaction_repository_;
        void update_account(const std::uint64_t account_id, const double amount, bool increase) ;
    };
}
