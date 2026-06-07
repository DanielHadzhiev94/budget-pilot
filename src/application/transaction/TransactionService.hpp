#pragma once

#include <QObject>

#include <cstdint>

#include "src/domain/models/Transaction.hpp"
#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::models {
    struct Account;
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
        explicit TransactionService(
            contracts::IRepository<models::Account> &account_repository,
            contracts::ITransactionRepository &transaction_repository
        );

        [[nodiscard]]
        utilities::Response<void> create_transaction(const models::Transaction &transaction);

        [[nodiscard]]
        utilities::Response<void> update_transaction(const models::Transaction &transaction);

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction>> load_all_by_month(int month, int year);

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction>> load_by_month(int month, int year, int limit);

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction>> load_income(int month, int year) const;

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction>> load_expense(int month, int year) const;

        [[nodiscard]]
        utilities::Response<double> calculate_monthly_saving_rate(int month, int year);

        [[nodiscard]]
        utilities::Response<void> delete_transaction(std::uint64_t id);

    signals:
        void transaction_changed();

    private:
        contracts::IRepository<models::Account> &account_repository_;
        contracts::ITransactionRepository &transaction_repository_;

        void synchronize_account_balance(std::uint64_t account_id);
    };
}
