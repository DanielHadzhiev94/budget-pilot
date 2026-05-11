#pragma once

#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::models {
    class Transaction;
    class Account;
}

namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services {
    class TransactionService {
    public:
        explicit TransactionService(contracts::IRepository<models::Account> &account_repository,
                                    contracts::IRepository<models::Transaction> &transaction_repository
        );

        [[nodiscard]]
        utilities::Response<void> create_transaction(const models::Transaction &transaction) const;

    private:
        contracts::IRepository<models::Account> &account_repository_;
        contracts::IRepository<models::Transaction> &transaction_repository_;
    };
}
