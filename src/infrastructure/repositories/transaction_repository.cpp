#include "transaction_repository.hpp"
#include "../../domain/model/transaction.hpp"
#include "src/infrastructure/persistence/statement.hpp"

using namespace budgetpilot::domain::model;


namespace budgetpilot::infrastructure::repositories {
    TransactionRepository::TransactionRepository(sqlite3 *connection)
            : connection_(connection) {
            if (!connection_) {
                throw std::invalid_argument("Database connection cannot be null.");
            }
    }

    void TransactionRepository::update(const Transaction &transaction) {
        const auto *sql = R"(
        UPDATE transactions
        SET account_id = ?, category_id = ?, type = ?, amount = ?, source = ?, note= ?, transaction_date = ?
        WHERE id = ?
    )";

        persistence::Statement stmt(connection_, sql);

        sqlite3_bind_int(stmt.get(), 1, static_cast<int>(transaction.account_id));
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.category_id));
        sqlite3_bind_int(stmt.get(), 3, static_cast<int>(transaction.type));
        sqlite3_bind_double(stmt.get(), 4, transaction.amount);
        sqlite3_bind_text(stmt.get(), 5, transaction.source.value().c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt.get(), 6, transaction.note.value().c_str(), -1, SQLITE_TRANSIENT);

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void TransactionRepository::add(const Transaction &transaction) {
        const auto *sql = R"(
            INSERT INTO transactions (account_id, category_id, type, amount, source, note, transaction_date)
            VALUES (?, ? ,? ,?, ?, ?, ?)
        )";

        const persistence::Statement stmt(connection_, sql);

        // Bind parameters
        sqlite3_bind_int(stmt.get(), 1, static_cast<int>(transaction.account_id));
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.category_id));
        sqlite3_bind_int(stmt.get(), 3, static_cast<int>(transaction.type));
        sqlite3_bind_double(stmt.get(), 4, transaction.amount);
        sqlite3_bind_text(stmt.get(), 5, transaction.source.value().c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt.get(), 6, transaction.note.value().c_str(), -1, SQLITE_TRANSIENT);

        auto seconds = convert_to_seconds(transaction.transaction_date);
        sqlite3_bind_int64(stmt.get(), 7, seconds);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(connection_));
        }
    }

    void TransactionRepository::remove(std::uint64_t id) {
        const auto *sql = R"(
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
        const auto *sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    )";

        const persistence::Statement stmt(connection_, sql);
        std::vector<Transaction> transactions{};
        while (sqlite3_step(stmt.get()) != SQLITE_DONE) {
            Transaction t{};
            t.id = sqlite3_column_int64(stmt.get(), 0);
            t.account_id = sqlite3_column_int(stmt.get(), 1);
            t.category_id = sqlite3_column_int(stmt.get(), 2);
            t.type = static_cast<Type>(sqlite3_column_int(stmt.get(), 3));
            t.amount = static_cast<float>(sqlite3_column_double(stmt.get(), 4));

            const unsigned char *source = sqlite3_column_text(stmt.get(), 5);
            t.source = source ? reinterpret_cast<const char *>(source) : "";

            const unsigned char *note = sqlite3_column_text(stmt.get(), 6);
            t.note = note ? reinterpret_cast<const char *>(note) : "";

            t.transaction_date = from_unix(sqlite3_column_int(stmt.get(), 7));

            const unsigned char *created_at = sqlite3_column_text(stmt.get(), 8);
            t.created_at = reinterpret_cast<const char *>(created_at);

            transactions.push_back(std::move(t));
        }

        return transactions;
    }

    std::optional<Transaction> TransactionRepository::getOne(std::uint64_t id) const {
        const auto sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    WHERE id = ?
                    )";

        const persistence::Statement stmt(connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_ROW) {
            Transaction t{};

            t.id = sqlite3_column_int64(stmt.get(), 0);
            t.account_id = sqlite3_column_int(stmt.get(), 1);
            t.category_id = sqlite3_column_int(stmt.get(), 2);
            t.type = static_cast<Type>(sqlite3_column_int(stmt.get(), 3));
            t.amount = static_cast<float>(sqlite3_column_double(stmt.get(), 4));

            const unsigned char *source = sqlite3_column_text(stmt.get(), 5);
            t.source = source ? reinterpret_cast<const char *>(source) : "";

            const unsigned char *note = sqlite3_column_text(stmt.get(), 6);
            t.note = note ? reinterpret_cast<const char *>(note) : "";

            t.transaction_date = from_unix(sqlite3_column_int(stmt.get(), 7));

            const unsigned char *created_at = sqlite3_column_text(stmt.get(), 8);
            t.created_at = reinterpret_cast<const char *>(created_at);

            return t;
        }

        if (result == SQLITE_DONE) {
            return std::nullopt;
        }

        throw std::runtime_error(sqlite3_errmsg(connection_));
    }

    std::int64_t TransactionRepository::convert_to_seconds(TimePoint time_point) {
        return std::chrono::duration_cast<std::chrono::seconds>(
            time_point.time_since_epoch()
        ).count();
    }

    std::chrono::system_clock::time_point TransactionRepository::from_unix(std::int64_t value) {
        return std::chrono::system_clock::time_point{
            std::chrono::seconds{value}
        };
    }
}
