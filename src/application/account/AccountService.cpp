#include "AccountsService.hpp"

#include <cmath>
#include <exception>
#include <string>
#include <vector>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/contracts/ITransactionRepository.hpp"
#include "src/domain/utilities/MonthYear.hpp"

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services
{
    AccountService::AccountService(
        contracts::IRepository<models::Account> &account_repository,
        contracts::ITransactionRepository &transaction_repository)
        : account_repository_(account_repository),
          transaction_repository_(transaction_repository)
    {
    }

    utilities::Response<void> AccountService::create_account(const models::Account account)
    {
        try
        {
            account_repository_.add(account);
            return utilities::Response<void>::Success("Account created");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Failed to create account: "} + ex.what());
        }
    }

    utilities::Response<std::vector<models::Account>> AccountService::load_accounts() const
    {
        try
        {
            auto accounts = account_repository_.get_all();
            return utilities::Response<std::vector<models::Account>>::Success(std::move(accounts));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Account>>::Failed(
                std::string{"Failed to get accounts: "} + ex.what());
        }
    }

    utilities::Response<void> AccountService::synchronize_accounts()
    {
        try
        {
            bool updated = false;
            auto accounts = account_repository_.get_all();

            for (auto &account : accounts)
            {
                const double calculated_balance = transaction_repository_.get_balance_by_account_id(
                    static_cast<int>(account.id));

                if (std::abs(calculated_balance - account.amount) <= 0.001)
                {
                    continue;
                }

                account.amount = calculated_balance;
                account_repository_.update(account);
                updated = true;
            }

            return utilities::Response<void>::Success(
                updated
                    ? "Differences found, accounts updated."
                    : "No account amount update needed.");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Failed to synchronize accounts: "} + ex.what());
        }
    }

    utilities::Response<void> AccountService::synchronize_accounts_for_last_three_months()
    {
        try
        {
            bool updated = false;
            auto accounts = account_repository_.get_all();
            const auto current_date = domain::utilities::MonthYear::current();

            for (auto &account : accounts)
            {
                double calculated_balance = 0.0;

                for (std::int32_t counter = 0; counter < 3; ++counter)
                {
                    const auto date = current_date.subtract_months(counter);
                    const auto transactions = transaction_repository_.get_by_date_and_account_id(
                        date.month,
                        date.year,
                        static_cast<int>(account.id));

                    for (const auto &transaction : transactions)
                    {
                        calculated_balance += transaction.type == enums::Type::Income
                                                  ? transaction.amount
                                                  : -transaction.amount;
                    }
                }

                if (std::abs(calculated_balance - account.amount) <= 0.001)
                {
                    continue;
                }

                account.amount = calculated_balance;
                account_repository_.update(account);
                updated = true;
            }

            return utilities::Response<void>::Success(
                updated
                    ? "Differences found, accounts updated."
                    : "No account amount update needed.");
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<void>::Failed(
                std::string{"Failed to synchronize accounts for the last three months: "} + ex.what());
        }
    }
}
