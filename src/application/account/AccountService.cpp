#include "AccountsService.hpp"

#include <exception>
#include <string>
#include <vector>
#include <ctime>

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

    utilities::Response<std::vector<models::Account>> AccountService::load_accounts() const
    {
        try
        {
            auto accounts = account_repository_.get_all();

            return utilities::Response<std::vector<models::Account>>::Success(
                std::move(accounts));
        }
        catch (const std::exception &ex)
        {
            return utilities::Response<std::vector<models::Account>>::Failed(
                std::string{"Failed to get accounts: "} + ex.what());
        }
    }

    utilities::Response<void> AccountService::synchronize_accounts()
    {
        bool updated = false;
        auto accounts = account_repository_.get_all();

        // Get current month and year dynamically
        auto current_date = domain::utilities::MonthYear::current();

        for (auto &acc : accounts)
        {
            std::int32_t counter = 0;
            std::int32_t transactions_amount = 0;
            while (counter < 3)
            {
                auto date = current_date.subtract_months(counter);
                const auto transactions = transaction_repository_.get_by_date_and_account_id(date.month, date.year, acc.id);
                for (const auto transaction : transactions)
                {
                    transactions_amount += transaction.type == enums::Type::Income
                                               ? transaction.amount
                                               : -transaction.amount;
                }
                counter++;
            }

            if (transactions_amount != acc.amount)
            {
                acc.amount = transactions_amount;
                account_repository_.update(acc);
                updated = true;
            }
        }

        return utilities::Response<void>::Success(updated
                                                      ? "There are differents found, acounts updated"
                                                      : "No update of the accounts amount needed.");
    }
}
