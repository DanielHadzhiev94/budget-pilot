#include "TransactionService.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"

namespace budgetpilot::application::transaction {
    TransactionService::TransactionService(AccountRepository *account_repository,
                                           TransactionRepository *transaction_repository
    )
        : account_repository_(account_repository), transaction_repository_(transaction_repository) {
    }

    Response<void> TransactionService::create_transaction(const Transaction &transaction) const {
        try {
            transaction_repository_->add(transaction);
            return Response<void>::Success("Transaction added successfully");
        } catch (const std::exception &ex) {
            return Response<void>::Failed(
                std::string{"Failed to create transaction: "} + ex.what()
            );
        }
    }
}
