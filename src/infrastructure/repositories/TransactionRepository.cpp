#include "TransactionRepository.hpp"

#include <stdexcept>

#include "../../domain/model/Transaction.hpp"
#include "src/infrastructure/persistence/Statement.hpp"
#include "../../domain/utilities/Timeconverter.hpp"
#include "../../domain/utilities/TimeConverter.hpp"

using namespace budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::infrastructure::repositories {
    TransactionRepository::TransactionRepository(sqlite3 &connection)
        : connection_(connection) {
    }

    void TransactionRepository::add(const Transaction &transaction) {
        const auto *sql = R"(
            INSERT INTO transactions (account_id, category_id, type, amount, source, note, transaction_date)
            VALUES (?, ? ,? ,?, ?, ?, ?)
        )";

        const persistence::Statement stmt(&connection_, sql);

        // Bind parameters
        sqlite3_bind_int(stmt.get(), 1, static_cast<int>(transaction.account_id));
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.category_id));
        sqlite3_bind_int(stmt.get(), 3, static_cast<int>(transaction.type));
        sqlite3_bind_double(stmt.get(), 4, transaction.amount);
        sqlite3_bind_text(stmt.get(), 5, transaction.source.value().c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt.get(), 6, transaction.note.value().c_str(), -1, SQLITE_TRANSIENT);

        auto seconds = domain::utilities::TimeConverter::convert_to_seconds(transaction.transaction_date);
        sqlite3_bind_int64(stmt.get(), 7, seconds);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void TransactionRepository::update(const Transaction &transaction) {
        const auto *sql = R"(
        UPDATE transactions
        SET account_id = ?, category_id = ?, type = ?, amount = ?, source = ?, note= ?, transaction_date = ?
        WHERE id = ?
    )";

        persistence::Statement stmt(&connection_, sql);

        sqlite3_bind_int(stmt.get(), 1, static_cast<int>(transaction.account_id));
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(transaction.category_id));
        sqlite3_bind_int(stmt.get(), 3, static_cast<int>(transaction.type));
        sqlite3_bind_double(stmt.get(), 4, transaction.amount);
        sqlite3_bind_text(stmt.get(), 5, transaction.source.value().c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt.get(), 6, transaction.note.value().c_str(), -1, SQLITE_TRANSIENT);

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void TransactionRepository::remove(const std::uint64_t &id) {
        const auto *sql = R"(
                             DELETE FROM transactions
                             WHERE id = ?
                            )";

        const persistence::Statement stmt(&connection_, sql);

        sqlite3_bind_int64(stmt.get(), 1, id);

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    std::vector<Transaction> TransactionRepository::get_all() {
        const auto *sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    ORDER BY created_at DESC
                    )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<Transaction> transactions{};

        while (sqlite3_step(stmt.get()) != SQLITE_DONE) {
            transactions.push_back(std::move(build_transaction_(stmt)));
        }

        return transactions;
    }

    std::optional<Transaction> TransactionRepository::get_one(const std::uint64_t &id) {
        const auto sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    WHERE id = ?
                    )";

        const persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_ROW) {
            return build_transaction_(stmt);
        }

        if (result == SQLITE_DONE) {
            return std::nullopt;
        }

        throw std::runtime_error(sqlite3_errmsg(&connection_));
    }

    std::vector<Transaction> TransactionRepository::get_all_by_month(int month, int year) {
        const auto *sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    WHERE transaction_date >=?
                        AND transaction_date < ?
                    ORDER BY created_at DESC
                    )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<Transaction> transactions{};

        const auto current_month_seconds = utilities::TimeConverter::to_unix_seconds(month, year);
        const auto next_month_seconds = utilities::TimeConverter::next_month_to_unix_seconds(month, year);

        sqlite3_bind_int64(stmt.get(), 1, current_month_seconds);
        sqlite3_bind_int64(stmt.get(), 2, next_month_seconds);

        int result{};

        while ((result = sqlite3_step(stmt.get())) == SQLITE_ROW) {
            transactions.push_back(build_transaction_(stmt));
        }

        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }

        return transactions;
    }

    std::vector<Transaction> TransactionRepository::get_all_by_month_and_type(int month, int year, enums::Type type) {
        const auto *sql = R"(
                    SELECT id, account_id, category_id, type, amount, source, note, transaction_date, created_at
                    FROM transactions
                    WHERE transaction_date >=?
                        AND transaction_date < ?
                        AND type = ?
                    ORDER BY created_at DESC
                    )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<Transaction> transactions{};

        const auto current_month_seconds = utilities::TimeConverter::to_unix_seconds(month, year);
        const auto next_month_seconds = utilities::TimeConverter::next_month_to_unix_seconds(month, year);

        sqlite3_bind_int64(stmt.get(), 1, current_month_seconds);
        sqlite3_bind_int64(stmt.get(), 2, next_month_seconds);
        sqlite3_bind_int(stmt.get(), 3, static_cast<int>(type));

        while (sqlite3_step(stmt.get()) != SQLITE_DONE) {
            transactions.push_back(std::move(build_transaction_(stmt)));
        }

        return transactions;
    }

    Transaction TransactionRepository::build_transaction_(const persistence::Statement &stmt) {
        Transaction transaction{};

        transaction.id = sqlite3_column_int64(stmt.get(), 0);
        transaction.account_id = sqlite3_column_int(stmt.get(), 1);
        transaction.category_id = sqlite3_column_int(stmt.get(), 2);
        transaction.type = static_cast<enums::Type>(sqlite3_column_int(stmt.get(), 3));
        transaction.amount = sqlite3_column_double(stmt.get(), 4);

        const unsigned char *source = sqlite3_column_text(stmt.get(), 5);
        transaction.source = source ? reinterpret_cast<const char *>(source) : "";

        const unsigned char *note = sqlite3_column_text(stmt.get(), 6);
        transaction.note = note ? reinterpret_cast<const char *>(note) : "";

        transaction.transaction_date = utilities::TimeConverter::from_unix(sqlite3_column_int(stmt.get(), 7));

        const unsigned char *created_at = sqlite3_column_text(stmt.get(), 8);
        transaction.created_at = reinterpret_cast<const char *>(created_at);

        return transaction;
    }
}
