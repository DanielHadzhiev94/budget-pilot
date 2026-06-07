#pragma once

#include <vector>

#include "src/domain/models/Account.hpp"
#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::contracts
{
    template <typename T>
    class IRepository;

    class ITransactionRepository;
}

namespace utilities = budgetpilot::domain::utilities;
namespace models = budgetpilot::domain::models;

namespace budgetpilot::application::services
{
    class AccountService
    {
    public:
        explicit AccountService(
            domain::contracts::IRepository<models::Account> &account_repository,
            domain::contracts::ITransactionRepository &transaction_repository);

        [[nodiscard]]
        utilities::Response<std::vector<models::Account>> load_accounts() const;

        [[nodiscard]]
        utilities::Response<void> synchronize_accounts();

        [[nodiscard]]
        utilities::Response<void> synchronize_accounts_for_last_three_months();

    private:
        domain::contracts::IRepository<models::Account> &account_repository_;
        domain::contracts::ITransactionRepository &transaction_repository_;
    };
}
