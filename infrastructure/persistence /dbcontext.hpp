#pragma once

#include <sqlite3.h>
#include <string>

namespace budgetpilot::infrastructure::persistence {
    class DbContext {
    public:
        explicit DbContext(const std::string &dbPath);

        ~DbContext();

        DbContext(const DbContext &) = delete;

        DbContext &operator =(const DbContext &) = delete;

        DbContext(const DbContext &&) = delete;

        DbContext &operator =(const DbContext &&) = delete;

        void initialize();

        [[nodiscard]] sqlite3 *getConnection() const;

    private :
        std::string dbPath_;
        sqlite3 *connection_ = nullptr;

        void open();

        void close();

        void createTable() const;
    };
}
