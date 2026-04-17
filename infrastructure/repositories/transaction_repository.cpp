#include "transaction_repository.hpp"

#include "domain/model/transaction.hpp"
#include "infrastructure/persistence /statement.hpp"

using namespace budgetpilot::domain::model;

namespace budgetpilot::infrastructure::repositories {
    TransactionRepository::TransactionRepository(sqlite3 *connection)
        : connection_(connection) {
        if (!connection_) {
            throw std::invalid_argument("Database connection cannot be null.");
        }
    }

    void TransactionRepository::add(const Transaction &transaction) {
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

    void TransactionRepository::update(const Transaction &transaction) {
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

    std::vector<Transaction> TransactionRepository::getAll() const {
        char *sql = R"(
                    SELECT id, source, type, amount, category_id
                    FROM transactions
                    )";

        const persistence::Statement stmt(connection_, sql);
        std::vector<Transaction> transactions{};
        while (sqlite3_step(stmt.get()) != SQLITE_DONE) {
            Transaction t{};
            t.id = sqlite3_column_int64(stmt.get(), 0);
            const unsigned char *source = sqlite3_column_text(stmt.get(), 1);
            t.source = source ? reinterpret_cast<const char *>(source) : "";
            t.type = static_cast<Type>(sqlite3_column_int(stmt.get(), 2));
            t.amount = static_cast<float>(sqlite3_column_double(stmt.get(), 3));
            t.category_id = sqlite3_column_int64(stmt.get(), 4);
            transactions.push_back(std::move(t));
        }

        return transactions;
    }

    std::optional<Transaction> TransactionRepository::getOne(std::uint64_t id) const {
        char *sql = R"(
                    SELECT id, source, type, amount, category_id
                    FROM transactions
                    WHERE id = ?
                    )";

        const persistence::Statement stmt(connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        int result = sqlite3_step(stmt.get());

        if (result == SQLITE_ROW) {
            Transaction t{};

            t.id = sqlite3_column_int64(stmt.get(), 0);

            const unsigned char *source = sqlite3_column_text(stmt.get(), 1);
            t.source = source ? reinterpret_cast<const char *>(source) : "";

            t.type = static_cast<Type>(sqlite3_column_int(stmt.get(), 2));
            t.amount = static_cast<float>(sqlite3_column_double(stmt.get(), 3));
            t.category_id = sqlite3_column_int64(stmt.get(), 4);

            return t;
        }

        if (result == SQLITE_DONE) {
            return std::nullopt;
        }

        throw std::runtime_error(sqlite3_errmsg(connection_));
    }
}
