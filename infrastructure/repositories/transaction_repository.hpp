#pragma once

#include <sqlite3.h>
#include <vector>

using TimePoint = std::chrono::system_clock::time_point;

namespace budgetpilot {
    namespace domain::model {
        struct Transaction;
        struct Category;
    }

    namespace infrastructure::repositories {
        class TransactionRepository {
        public:
            explicit TransactionRepository(sqlite3 *connection);

            void add(const domain::model::Transaction &transaction);
            void update(const domain::model::Transaction &transaction);
            void remove(std::uint64_t id);

            [[nodiscard]] std::vector<domain::model::Transaction> getAll() const;
            [[nodiscard]] std::optional<domain::model::Transaction> getOne(std::uint64_t id) const;

        private:
            sqlite3 *connection_;
            static std::int64_t convert_to_seconds(TimePoint time_point);
            static std::chrono::system_clock::time_point from_unix(std::int64_t value);
        };
    }
}
