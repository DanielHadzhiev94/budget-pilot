#include "AccountsService.hpp"

#include "src/domain/contracts/IRepository.hpp"

namespace budgetpilot::application::accounts {
    using namespace domain::model;
    using namespace domain::utilities;

    AccountService::AccountService(domain::contracts::IRepository<Account> &account_repository)
        : account_repository_(account_repository) {
    }

    Response<std::vector<Account> > AccountService::load_accounts() const {
        try {
            const auto accounts = account_repository_.getAll();
            return Response<std::vector<Account> >::Success(accounts);
        } catch (std::exception &ex) {
            return Response<std::vector<Account> >::Failed(
                std::string{"Failed to get accounts"} + ex.what()
            );
        }
    }
}
