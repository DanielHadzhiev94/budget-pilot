#include <filesystem>
#include "DbContext.hpp"

namespace budgetpilot::infrastructure::persistence {
    DbContext::DbContext(const std::string &db_path)
        : db_path_(db_path) {
    }

    DbContext::~DbContext() {
        close();
    }

    void DbContext::initialize() {
        open();
        createTable();
        seedCategories();
    }

    void DbContext::open() {
        if (connection_ != nullptr) {
            return;
        }

        std::int32_t result = sqlite3_open(db_path_.c_str(), &connection_);
        if (result != SQLITE_OK) {
            std::string errorMessage = connection_ != nullptr
                                           ? sqlite3_errmsg(connection_)
                                           : "Failed to open SQLite database.";

            close();
            throw std::runtime_error(errorMessage);
        }
    }

    void DbContext::close() {
        if (connection_ == nullptr) {
            return;
        }

        sqlite3_close(connection_);
        connection_ = nullptr;
    }

    void DbContext::createTable() const {
        const char *account_query = R"(
                CREATE TABLE IF NOT EXISTS accounts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                initial_balance REAL NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );
        )";

        const char *category_query = R"(
        CREATE TABLE IF NOT EXISTS categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );
        )";

        const char *transaction_query = R"(
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            account_id INTEGER NOT NULL,
            category_id INTEGER NOT NULL,
            type INTEGER NOT NULL CHECK(type IN (1, 2)),
            amount REAL NOT NULL CHECK(amount > 0),
            source TEXT,
            note TEXT,
            transaction_date INTEGER NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY (account_id) REFERENCES accounts(id),
            FOREIGN KEY (category_id) REFERENCES categories(id)
           );
        )";

        execute(account_query);
        execute(category_query);
        execute(transaction_query);
        execute("PRAGMA foreign_keys = ON;");
    }

    void DbContext::seedCategories() const {
        const char *category_seed = R"(
        INSERT OR IGNORE INTO categories (name) VALUES ('Salary');
        INSERT OR IGNORE INTO categories (name) VALUES ('Food');
        INSERT OR IGNORE INTO categories (name) VALUES ('Apartment');
    )";

        const char *acc_seed = R"(
        INSERT OR IGNORE INTO accounts (name, initial_balance) VALUES('Bank', 1234);
)";

        execute(category_seed);
        execute(acc_seed);
    }

    void DbContext::execute(const char *query) const {
        if (connection_ == nullptr) {
            throw std::runtime_error("Database connection is not open.");
        }
        char *errMsg = nullptr;

        int result = sqlite3_exec(connection_, query, nullptr, nullptr, &errMsg);
        if (result != SQLITE_OK) {
            std::string error = errMsg ? errMsg : "Unknown SQL error";
            sqlite3_free(errMsg);
            throw std::runtime_error(error);
        }
    }

    sqlite3 *DbContext::getConnection() const {
        return connection_;
    }
}
