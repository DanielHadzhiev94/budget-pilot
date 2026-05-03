#include "TransactionService.hpp"

namespace budgetpilot::application::transaction {
    TransactionService::TransactionService(AccountRepository *account_repository,
                                           TransactionRepository *transaction_repository
    )
        : account_repository_(account_repository), transaction_repository_(transaction_repository) {
    }


}
