#include "transaction_repository.hpp"

#include "domain/model/transaction.hpp"
#include "infrastructure/persistence /statement.hpp"

namespace budgetpilot::infrastructure::repositories {
    TransactionRepository::TransactionRepository(sqlite3 *connection)
        : connection_(connection) {
        if (!connection_) {
            throw std::invalid_argument("Database connection cannot be null.");
        }
    }

    void TransactionRepository::add(const domain::model::Transaction &transaction) {
        const char *sql = R"(
            INSERT INTO transactions (amount, type, source, category_id)
            VALUES (?, ? ,? ,?))";

        const persistence::Statement stmt(connection_, sql);

        // Bind parameters
        sqlite3_bind_double(stmt.get(), 1, transaction.amount);
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.type));
        sqlite3_bind_text(stmt.get(), 3, transaction.source.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt.get(), 4, static_cast<int>(transaction.category_id));

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void TransactionRepository::update(const domain::model::Transaction &transaction) {
        const char *sql = R"(
        UPDATE transactions
        SET amount = ?, type = ?, source = ?, category_id = ?
        WHERE id = ?
    )";

        persistence::Statement stmt(connection_, sql);

        sqlite3_bind_double(stmt.get(), 1, transaction.amount);
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.type));
        sqlite3_bind_text(stmt.get(), 3, transaction.source.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt.get(), 4, static_cast<int>(transaction.category_id));
        sqlite3_bind_int64(stmt.get(), 5, static_cast<sqlite3_int64>(transaction.id));

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void TransactionRepository::remove(std::uint64_t id) {
        const char *sql = R"(
                             DELETE FROM transactions
                             WHERE id = ?
                            )";

        const persistence::Statement stmt(connection_, sql);

        sqlite3_bind_int64(stmt.get(), 1, id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }
}
