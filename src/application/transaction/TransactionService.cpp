#include "TransactionService.hpp"

#include <cmath>
#include <cstdint>
#include <exception>
#include <string>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/models/Account.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"

namespace contracts = budgetpilot::domain::contracts;
namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::application::services
{
    TransactionService::TransactionService(
        contracts::IRepository<models::Account> &account_repository,
        contracts::ITransactionRepository &transaction_repository)
        : account_repository_(account_repository),
          transaction_repository_(transaction_repository)
    {
    }

    utilities::Response<void> TransactionService::create_transaction(const models::Transaction &transaction)
    {
        try
        {
            transaction_repository_.add(transaction);
            synchronize_account_balance(transaction.account_id);

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction added successfully.");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Failed to create transaction: "} + ex.what());
        }
    }

    utilities::Response<void> TransactionService::update_transaction(const models::Transaction &transaction)
    {
        try
        {
            const auto old_transaction = transaction_repository_.get_one(transaction.id);
            if (!old_transaction.has_value())
            {
                return utilities::Response<void>::Failed(
                    std::string{"Transaction with id: "} + std::to_string(transaction.id) + " not found.");
            }

            transaction_repository_.update(transaction);

            // Recalculate instead of applying a difference. This handles amount, type,
            // account and category changes correctly.
            synchronize_account_balance(old_transaction->account_id);
            if (old_transaction->account_id != transaction.account_id)
            {
                synchronize_account_balance(transaction.account_id);
            }

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction updated successfully.");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Failed to update transaction: "} + ex.what());
        }
    }

    utilities::Response<std::vector<models::Transaction>> TransactionService::load_all_by_month(const int month,
                                                                                                const int year)
    {
        try
        {
            auto transactions = transaction_repository_.get_all_by_month(month, year);
            if (transactions.empty())
            {
                return utilities::Response<std::vector<models::Transaction>>::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year));
            }

            return utilities::Response<std::vector<models::Transaction>>::Success(std::move(transactions));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Transaction>>::Failed(
                std::string{"Failed to get transactions: "} + ex.what());
        }
    }

    utilities::Response<std::vector<models::Transaction>> TransactionService::load_by_month(
        const int month, const int year, const int limit)
    {
        try
        {
            auto transactions = transaction_repository_.get_by_month(month, year, limit);
            if (transactions.empty())
            {
                return utilities::Response<std::vector<models::Transaction>>::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year));
            }

            return utilities::Response<std::vector<models::Transaction>>::Success(std::move(transactions));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Transaction>>::Failed(
                std::string{"Failed to get transactions: "} + ex.what());
        }
    }

    utilities::Response<std::vector<models::Transaction>> TransactionService::load_income(const int month,
                                                                                          const int year) const
    {
        try
        {
            auto income_data = transaction_repository_.get_all_by_month_and_type(month, year, enums::Type::Income);
            if (income_data.empty())
            {
                return utilities::Response<std::vector<models::Transaction>>::Failed(
                    std::string{"No income data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year));
            }

            return utilities::Response<std::vector<models::Transaction>>::Success(std::move(income_data));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Transaction>>::Failed(
                std::string{"Failed to load income data: "} + ex.what());
        }
    }

    utilities::Response<std::vector<models::Transaction>> TransactionService::load_expense(const int month,
                                                                                           const int year) const
    {
        try
        {
            auto expense_data = transaction_repository_.get_all_by_month_and_type(
                month, year, enums::Type::Expense);

            if (expense_data.empty())
            {
                return utilities::Response<std::vector<models::Transaction>>::Failed(
                    std::string{"No expense data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year));
            }

            return utilities::Response<std::vector<models::Transaction>>::Success(std::move(expense_data));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Transaction>>::Failed(
                std::string{"Failed to load expense data: "} + ex.what());
        }
    }

    utilities::Response<double> TransactionService::calculate_monthly_saving_rate(int month, int year)
    {
        try
        {
            const auto transaction_data = transaction_repository_.get_all_by_month(month, year);
            if (transaction_data.empty())
            {
                return utilities::Response<double>::Failed(
                    std::string{"No transaction data found for the period "} +
                    std::to_string(month) +
                    "-" +
                    std::to_string(year));
            }

            double transaction_sum{0.0};
            for (const auto &transaction : transaction_data)
            {
                transaction_sum +=
                    transaction.type == enums::Type::Income
                        ? transaction.amount
                        : -transaction.amount;
            }

            return utilities::Response<double>::Success(transaction_sum);
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<double>::Failed(
                std::string{"Failed to load transaction data: "} + ex.what());
        }
    }

    utilities::Response<void> TransactionService::delete_transaction(const std::uint64_t id)
    {
        try
        {
            const auto transaction = transaction_repository_.get_one(id);
            if (!transaction.has_value())
            {
                return utilities::Response<void>::Failed(
                    std::string{"Transaction with id: "} + std::to_string(id) + " not found.");
            }

            transaction_repository_.remove(id);
            synchronize_account_balance(transaction->account_id);

            emit transaction_changed();

            return utilities::Response<void>::Success("Transaction successfully deleted.");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Cannot delete the transaction: "} + ex.what());
        }
    }

    void TransactionService::synchronize_account_balance(const std::uint64_t account_id)
    {
        auto account = account_repository_.get_one(account_id);
        if (!account.has_value())
        {
            throw std::runtime_error("Account not found.");
        }

        const double calculated_balance = transaction_repository_.get_balance_by_account_id(
            static_cast<int>(account_id));

        if (std::abs(account->amount - calculated_balance) <= 0.001)
        {
            return;
        }

        account->amount = calculated_balance;
        account_repository_.update(*account);
    }
}
