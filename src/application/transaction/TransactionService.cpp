#include "TransactionService.hpp"

#include<cstdint>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/model/Account.hpp"
#include "src/domain/model/Transaction.hpp"

namespace contracts = budgetpilot::domain::contracts;
namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::application::services {
    TransactionService::TransactionService(contracts::IRepository<models::Account> &account_repository,
                                           contracts::IRepository<models::Transaction> &transaction_repository)
        : account_repository_(account_repository),
          transaction_repository_(transaction_repository) {
    }

    utilities::Response<void> TransactionService::create_transaction(const models::Transaction &transaction) {
        try {
            auto acc_opt = account_repository_.getOne(transaction.account_id);

            // If there is an account, add  the value
            if (acc_opt.has_value()) {
                acc_opt->amount +=
                        transaction.type == models::Type::Income
                            ? transaction.amount
                            : -transaction.amount;

                account_repository_.update(*acc_opt);
            }

            transaction_repository_.add(transaction);
            emit transaction_created();

            return utilities::Response<void>::Success("Transaction added successfully");
        } catch (const std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Failed to create transaction: "} + ex.what()
            );
        }
    }
}
