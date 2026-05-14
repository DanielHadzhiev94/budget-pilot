#include "TransactionService.hpp"

#include<cstdint>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/model/Account.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"

namespace contracts = budgetpilot::domain::contracts;
namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::application::services {
    TransactionService::TransactionService(contracts::IRepository<models::Account> &account_repository,
                                           contracts::ITransactionRepository &transaction_repository)
        : account_repository_(account_repository),
          transaction_repository_(transaction_repository) {
    }

    utilities::Response<void> TransactionService::create_transaction(const models::Transaction &transaction) {
        try {
            auto acc_opt = account_repository_.getOne(transaction.account_id);

            // If there is an account, add  the value
            if (acc_opt.has_value()) {
                acc_opt->amount +=
                        transaction.type == enums::Type::Income
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

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_income_data(const int month,
        const int year) const {
        try {
            const auto income_data = transaction_repository_.getAllByMonthAndType(month, year, enums::Type::Income);

            if (income_data.capacity() == 0)
                return utilities::Response<std::vector<models::Transaction> >::Failed(
                    std::string{"No income data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year)
                );
            return utilities::Response<std::vector<models::Transaction> >::Success(
                income_data);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Transaction> >::Failed(
                std::string{"Failed to load income data"} + ex.what()
            );
        }
    }

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_expense_data(const int month,
        const int year) const {
        try {
            const auto income_data = transaction_repository_.getAllByMonthAndType(month, year, enums::Type::Expense);

            if (income_data.capacity() == 0)
                return utilities::Response<std::vector<models::Transaction> >::Failed(
                    std::string{"No expense data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year)
                );
            return utilities::Response<std::vector<models::Transaction> >::Success(
                income_data);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Transaction> >::Failed(
                std::string{"Failed to load expense data"} + ex.what()
            );
        }
    }
}
