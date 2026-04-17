#pragma once
#include <sqlite3.h>


namespace budgetpilot::infrastructure::persistence {
    class Statement {
    public:
        explicit Statement(sqlite3 *connection, const char *sql);
        ~Statement();

        Statement(const Statement &) = delete;
        Statement &operator =(const Statement &) = delete;

        Statement(Statement &&) = delete;
        Statement &&operator =(Statement &&) = delete;

        [[nodiscard]] sqlite3_stmt *get() const;

    private:
        sqlite3_stmt *stmt_;
    };
}
