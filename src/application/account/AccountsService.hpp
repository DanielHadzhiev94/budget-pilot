#pragma once

#include <vector>

#include "src/domain/model/Account.hpp"
#include "src/domain/utilities/Response.hpp"

namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace budgetpilot::application::account {
    class AccountService {
    public:
        explicit AccountService(
            domain::contracts::IRepository<domain::model::Account> &account_repository
        );

        [[nodiscard]]
        domain::utilities::Response<std::vector<domain::model::Account> > load_accounts() const;

    private:
        domain::contracts::IRepository<domain::model::Account> &account_repository_;
    };
}
