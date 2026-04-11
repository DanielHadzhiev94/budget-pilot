#include "dbcontext.hpp"

namespace budgetpilot::infrastructure::persistence {
    DbContext::DbContext(const std::string &dbPath)
        : dbPath_(dbPath) {
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

        std::int32_t result = sqlite3_open(dbPath_.c_str(), &connection_);
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
        if (connection_ == nullptr) {
            throw std::runtime_error("Database connection is not open.");
        }

        char *errMsg = nullptr;

        int result = sqlite3_exec(connection_, R"(
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            source TEXT
        );
    )", nullptr, nullptr, &errMsg);

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
