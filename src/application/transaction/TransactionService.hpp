#pragma once
#include "src/domain/utilities/Reponse.hpp"

namespace budgetpilot {
    namespace infrastructure::repositories {
        class TransactionRepository;
        class AccountRepository;
    };

    namespace domain::model {
        class Transaction;
    }

    using namespace infrastructure::repositories;
    using namespace domain::model;
    using namespace domain::utilities;

    namespace application::transaction {
        class TransactionService {
        public:
            explicit TransactionService(AccountRepository *account_repository,
                                        TransactionRepository *transaction_repository
            );

            [[nodiscard]] Response<void> create_transaction(const Transaction &transaction) const;

        private:
            AccountRepository *account_repository_;
            TransactionRepository *transaction_repository_;
        };
    }
}
