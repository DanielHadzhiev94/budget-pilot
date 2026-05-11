#pragma once

#include <vector>

#include "AccountsService.hpp"
#include "src/domain/model/Account.hpp"
#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace utilities = budgetpilot::domain::utilities;
namespace models = budgetpilot::domain::models;

namespace budgetpilot::application::services {
    class AccountService {
    public:
        explicit AccountService(
            domain::contracts::IRepository<models::Account> &account_repository
        );

        [[nodiscard]]
        utilities::Response<std::vector<models::Account> > load_accounts() const;

    private:
        domain::contracts::IRepository<models::Account> &account_repository_;
    };
}
