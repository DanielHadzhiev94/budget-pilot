#include "dbcontext.hpp"

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

        const char *transaction_query = R"(
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            source TEXT,
            category_id INTEGER NOT NULL,
            FOREIGN KEY (category_id) REFERENCE category(id)
        );
    )";
        const char *category_query = R"(
        CREATE TABLE IF NOT EXISTS categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        );
    )";

        execute(transaction_query);
        execute(category_query);
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
