#pragma once

#include <sqlite3.h>
#include <vector>

#include "../../domain/interfaces/repository.hpp"


namespace budgetpilot {
    namespace domain::model {
        struct Account;
    }

    using namespace domain::model;

    namespace infrastructure::repositories {
        class AccountRepository : public domain::interface::IRepository<Account> {

        public:
            explicit AccountRepository(sqlite3 *connection);

            void add(Account account) override;
            void update(Account account) override;
            void remove(std::uint64_t id) override;

            std::vector<Account> getAll() override;
            Account getOne(std::uint64_t id) override;

        private:
            sqlite3 *connection_;
        };
    }
}
