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

namespace budgetpilot::application::services {
    class TransactionService {
    public:
        explicit TransactionService(domain::contracts::IRepository<domain::models::Account> &account_repository,
                                    domain::contracts::IRepository<domain::models::Transaction> &transaction_repository
        );

        [[nodiscard]]
        domain::utilities::Response<void> create_transaction(const domain::models::Transaction &transaction) const;

    private:
        domain::contracts::IRepository<domain::models::Account> &account_repository_;
        domain::contracts::IRepository<domain::models::Transaction> &transaction_repository_;
    };
}
