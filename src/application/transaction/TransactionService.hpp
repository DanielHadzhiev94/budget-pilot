#pragma once

namespace budgetpilot {
    namespace infrastructure::repositories {
        class TransactionRepository;
        class AccountRepository;
    };

    using namespace infrastructure::repositories;

    namespace application::transaction {
        class TransactionService {
        public:
            explicit TransactionService(AccountRepository *account_repository,
                                        TransactionRepository *transaction_repository
            );

        private:
            AccountRepository *account_repository_;
            TransactionRepository *transaction_repository_;
        };
    }
}
