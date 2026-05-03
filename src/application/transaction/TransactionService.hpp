#pragma once
#include "src/infrastructure/repositories/AccountRepository.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"


namespace budgetpilot {
    using namespace infrastructure::repositories;

    namespace application::transaction {
        class TransactionService {
        public:
            explicit TransactionService(TransactionRepository *transaction_repository,
                                        AccountRepository *account_repository);



        private:
            AccountRepository *account_repository_;
            TransactionRepository *transaction_repository_;
        };
    }
}
