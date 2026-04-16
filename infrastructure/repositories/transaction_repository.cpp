#include "transaction_repository.hpp"

#include "domain/model/transaction.hpp"

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

        sqlite3_stmt *stmt = nullptr;
        int result = sqlite3_prepare_v2(connection_, sql, -1, &stmt, nullptr);
        if (result != SQLITE_OK) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }

        // Bind parameters
        sqlite3_bind_double(stmt, 1, transaction.amount);
        sqlite3_bind_int(stmt, 2, static_cast<int>(transaction.type));
        sqlite3_bind_text(stmt, 3, transaction.source.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt, 4, static_cast<int>(transaction.category_id));

        result = sqlite3_step(stmt);
        if (result != SQLITE_DONE) {
            sqlite3_finalize(stmt);
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }


        sqlite3_finalize(stmt);
    }
}
