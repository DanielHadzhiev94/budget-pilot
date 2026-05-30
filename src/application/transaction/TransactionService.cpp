#include "TransactionService.hpp"

#include<cstdint>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/models/Account.hpp"
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
            bool should_increase = transaction.type == enums::Type::Income;
            update_account(transaction.account_id, transaction.amount, should_increase);
            transaction_repository_.add(transaction);

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction added successfully");
        } catch (const std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Failed to create transaction: "} + ex.what()
            );
        }
    }

    utilities::Response<void> TransactionService::update_transaction(const models::Transaction &transaction) {
        try {
            const auto old_transaction_opt = transaction_repository_.get_one(transaction.id);

            if (!old_transaction_opt.has_value())
                return utilities::Response<void>::Failed(std::string{"Transaction with id: "}
                                                         + std::to_string(transaction.id)
                                                         + " not found!");

            const auto old_amount = old_transaction_opt.value().amount;
            const auto amount_difference = transaction.amount - old_amount;

            bool should_increase = transaction.type == enums::Type::Income;
            update_account(transaction.account_id, amount_difference, should_increase);

            transaction_repository_.update(transaction);

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction updated successfully");
        } catch (const std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Failed to update transaction: "} + ex.what()
            );
        }
    }

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_all_by_month(const int month,
        const int year) {
        try {
            const auto &transactions = transaction_repository_.get_all_by_month(month, year);
            if (transactions.capacity() <= 0)
                return utilities::Response<std::vector<models::Transaction> >::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year)
                );

            return utilities::Response<std::vector<models::Transaction> >::Success(transactions);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Transaction> >::Failed(
                std::string{"Failed to get transactions: "} + ex.what()
            );
        }
    }

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_by_month(
        const int month, const int year, const int limit) {
        try {
            const auto &transactions = transaction_repository_.get_by_month(month, year, limit);
            if (transactions.capacity() <= 0)
                return utilities::Response<std::vector<models::Transaction> >::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year)
                );

            return utilities::Response<std::vector<models::Transaction> >::Success(transactions);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Transaction> >::Failed(
                std::string{"Failed to get transactions: "} + ex.what()
            );
        }
    }

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_income(const int month,
        const int year) const {
        try {
            const auto income_data = transaction_repository_.
                    get_all_by_month_and_type(month, year, enums::Type::Income);

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

    utilities::Response<std::vector<models::Transaction> > TransactionService::load_expense(const int month,
        const int year) const {
        try {
            const auto income_data = transaction_repository_.get_all_by_month_and_type(
                month, year, enums::Type::Expense);

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

    utilities::Response<double> TransactionService::calculate_monthly_saving_rate(int month, int year) {
        try {
            const auto &transaction_data = transaction_repository_.get_all_by_month(month, year);
            if (transaction_data.capacity() == 0) {
                return utilities::Response<double>::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year)
                );
            }

            double transaction_sum{0.0};
            for (const auto &transaction: transaction_data) {
                transaction_sum +=
                        transaction.type == enums::Type::Income
                            ? transaction.amount
                            : -transaction.amount;
            }

            return utilities::Response<double>::Success(transaction_sum);
        } catch (std::exception &ex) {
            return utilities::Response<double>::Failed(
                std::string{"Failed to load transaction data"} + ex.what()
            );
        }
    }

    utilities::Response<void> TransactionService::delete_transaction(const std::uint64_t id) {
        try {
            const auto transaction_opt = transaction_repository_.get_one(id);
            if (!transaction_opt.has_value()) {
                return utilities::Response<void>::Failed(std::string{"Transaction with id: "}
                                                         + std::to_string(id)
                                                         + "not found!");
            }

            const models::Transaction *transaction = &transaction_opt.value();
            bool should_increase = transaction->type == enums::Type::Expense;
            update_account(transaction->account_id, transaction->amount, should_increase);

            transaction_repository_.remove(transaction->id);

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction successfully deleted!");
        } catch (std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Cannot delete the transaction "} + ex.what()
            );
        }
    }

    void TransactionService::update_account(const std::uint64_t account_id, const double amount, bool increase) {
        auto acc_opt = account_repository_.get_one(account_id);
        // If we remove expense, then increase the balance otherwise decrease it
        if (acc_opt.has_value()) {
            acc_opt->amount += increase
                                   ? amount
                                   : -amount;

            account_repository_.update(*acc_opt);
        }
    }
}
