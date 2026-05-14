#include "AccountsService.hpp"

#include <exception>
#include <string>
#include <vector>

#include "src/domain/contracts/IRepository.hpp"


namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services {
    AccountService::AccountService(contracts::IRepository<models::Account> &account_repository)
        : account_repository_{account_repository} {
    }

    utilities::Response<std::vector<models::Account> > AccountService::load_accounts() const {
        try {
            auto accounts = account_repository_.getAll();

            return utilities::Response<std::vector<models::Account> >::Success(
                std::move(accounts)
            );
        } catch (const std::exception &ex) {
            return utilities::Response<std::vector<models::Account> >::Failed(
                std::string{"Failed to get accounts: "} + ex.what()
            );
        }
    }
}
