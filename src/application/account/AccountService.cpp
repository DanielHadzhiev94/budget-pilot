#include "AccountsService.hpp"

#include "src/domain/contracts/IRepository.hpp"

#include <exception>
#include <string>
#include <vector>


namespace budgetpilot::application::account {

    namespace model = domain::model;
    namespace utilities = domain::utilities;
    namespace contracts = domain::contracts;

    AccountService::AccountService(contracts::IRepository<model::Account>& account_repository)
        : account_repository_(account_repository) {
    }

    utilities::Response<std::vector<model::Account>> AccountService::load_accounts() const {
        try {
            auto accounts = account_repository_.getAll();

            return utilities::Response<std::vector<model::Account>>::Success(
                std::move(accounts)
            );
        } catch (const std::exception& ex) {
            return utilities::Response<std::vector<model::Account>>::Failed(
                std::string{"Failed to get accounts: "} + ex.what()
            );
        }
    }

}