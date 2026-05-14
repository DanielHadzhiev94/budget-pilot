#pragma once

#include <QObject>

#include "src/domain/model/Transaction.hpp"
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
        utilities::Response<std::vector<models::Transaction> > load_income_data(
            const int month, const int year) const;

        [[nodiscard]]
        utilities::Response<std::vector<models::Transaction> > load_expense_data(
            const int month, const int year) const;

    signals:
        void transaction_created();

    private:
        contracts::IRepository<models::Account> &account_repository_;
        contracts::ITransactionRepository &transaction_repository_;
    };
}
