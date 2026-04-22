#include <stdexcept>
#include "statement.hpp"

namespace budgetpilot::infrastructure::persistence {
    Statement::Statement(sqlite3 *db, const char *sql)
        : stmt_(nullptr) {
        int result = sqlite3_prepare_v2(db, sql, -1, &stmt_, nullptr);
        if (result != SQLITE_OK) {
            throw std::runtime_error(sqlite3_errmsg(db));
        }
    }

    Statement::~Statement() {
        if (stmt_) {
            sqlite3_finalize(stmt_);
            stmt_ = nullptr;
        }
    }

    sqlite3_stmt *Statement::get() const {
        return stmt_;
    }
}
