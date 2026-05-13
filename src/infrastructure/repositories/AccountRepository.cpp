#include <stdexcept>

#include "AccountRepository.hpp"

#include <cstdint>

#include "../../domain/model/Account.hpp"
#include "src/infrastructure/persistence/Statement.hpp"


namespace models = budgetpilot::domain::models;

namespace budgetpilot::infrastructure::repositories {
    AccountRepository::AccountRepository(sqlite3 &connection)
        : connection_(connection) {
    }

    void AccountRepository::add(const models::Account &entity) {
        const auto sql = R"(
                    INSERT INTO accounts (name, initial_balance)
                    VALUES(?,?)
                    )";

        const persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt.get(), 2, entity.amount);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void AccountRepository::update(const models::Account &entity) {
        const auto sql = R"(
                    UPDATE accounts
                    SET name = ?, initial_balance = ?
                    WHERE id = ?
                    )";

        const persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt.get(), 2, entity.amount);
        sqlite3_bind_int64(stmt.get(), 3, entity.id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void AccountRepository::remove(const std::uint64_t &id) {
        auto sql = R"(
                      DELETE account
                      WHERE id = ?
                     )";

        const persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    std::optional<models::Account> AccountRepository::getOne(const std::uint64_t &id) {
        const char *sql = R"(
        SELECT id, name, initial_balance, created_at
        FROM accounts
        WHERE id = ?
    )";

        persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_DONE) {
            throw std::runtime_error("Account not found");
        }

        if (result != SQLITE_ROW) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }

        models::Account account{};

        account.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

        const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
        account.name = name ? reinterpret_cast<const char *>(name) : "";

        account.amount = sqlite3_column_double(stmt.get(), 2);

        const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
        account.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

        return account;
    }

    std::vector<models::Account> AccountRepository::getAll(int month, int year) {
        const auto *sql = R"(
                    SELECT id, name, initial_balance, created_at
                    FROM accounts
                    )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<models::Account> accounts{};

        while (sqlite3_step(stmt.get()) == SQLITE_ROW) {
            models::Account acc{};

            acc.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

            const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
            acc.name = name ? reinterpret_cast<const char *>(name) : "";

            acc.amount = sqlite3_column_double(stmt.get(), 2);

            const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
            acc.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

            accounts.push_back(std::move(acc));
        }

        return accounts;
    }
}
