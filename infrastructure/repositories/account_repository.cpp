#include "account_repository.hpp"

#include "domain/model/account.hpp"
#include "infrastructure/persistence /dbcontext.hpp"
#include "infrastructure/persistence /statement.hpp"

using namespace budgetpilot::domain::model;

namespace budgetpilot::infrastructure::repositories {
    AccountRepository::AccountRepository(sqlite3 *connection)
        : connection_(connection) {
        if (!connection_) {
            throw std::invalid_argument("Database connection cannot be null.");
        }
    }

    void AccountRepository::add(Account account) {
        const auto sql = R"(
                    INSERT INTO accounts (name, initial_balance)
                    VALUES(?,?)
                    )";

        const persistence::Statement stmt(connection_, sql);
        sqlite3_bind_text(stmt.get(), 1, account.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt.get(), 2, account.amount);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void AccountRepository::update(Account account) {
        const auto sql = R"(
                    UPDATE accounts
                    SET name = ?, initial_balance = ?
                    WHERE id = ?
                    )";

        const persistence::Statement stmt(connection_, sql);
        sqlite3_bind_text(stmt.get(), 1, account.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt.get(), 2, account.amount);
        sqlite3_bind_int64(stmt.get(), 3, account.id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void AccountRepository::remove(std::uint64_t id) {
        auto sql = R"(
                      DELETE account
                      WHERE id = ?
                     )";

        const persistence::Statement stmt(connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    std::vector<Account> AccountRepository::getAll() {
        const auto *sql = R"(
                    SELECT id, name, initial_balance, created_at
                    FROM accounts
                    )";

        const persistence::Statement stmt(connection_, sql);
        std::vector<Account> accounts{};

        while (sqlite3_step(stmt.get()) == SQLITE_ROW) {
            Account acc{};

            acc.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

            const unsigned char* name = sqlite3_column_text(stmt.get(), 1);
            acc.name = name ? reinterpret_cast<const char*>(name) : "";

            acc.amount = sqlite3_column_double(stmt.get(), 2);

            const unsigned char* created_at = sqlite3_column_text(stmt.get(), 3);
            acc.created_at = created_at ? reinterpret_cast<const char*>(created_at) : "";

            accounts.push_back(std::move(acc));
        }

        return accounts;
    }

    Account AccountRepository::getOne(std::uint64_t id) {
        const char* sql = R"(
        SELECT id, name, initial_balance, created_at
        FROM accounts
        WHERE id = ?
    )";

        persistence::Statement stmt(connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_DONE) {
            throw std::runtime_error("Account not found");
        }

        if (result != SQLITE_ROW) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }

        Account account{};

        account.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

        const unsigned char* name = sqlite3_column_text(stmt.get(), 1);
        account.name = name ? reinterpret_cast<const char*>(name) : "";

        account.amount = sqlite3_column_double(stmt.get(), 2);

        const unsigned char* created_at = sqlite3_column_text(stmt.get(), 3);
        account.created_at = created_at ? reinterpret_cast<const char*>(created_at) : "";

        return account;
    }
}
