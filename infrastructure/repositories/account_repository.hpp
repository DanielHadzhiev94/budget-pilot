#pragma once
#include <sqlite3.h>
#include <vector>


namespace budgetpilot {
    namespace domain::model {
        struct Account;
    }

    namespace infrastructure::repositories {
        class AccountRepository {
        public:
            explicit AccountRepository(sqlite3 *connection);

            void add(domain::model::Account account);
            void update(domain::model::Account account);
            void remove(domain::model::Account account);

            static std::vector<domain::model::Account> getAll();
            static domain::model::Account getOne(std::uint64_t id);

        private:
            sqlite3 *connection_;
        };
    }
}
