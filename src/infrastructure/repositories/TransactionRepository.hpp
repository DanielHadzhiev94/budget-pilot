#pragma once

#include <chrono>
#include <optional>
#include <vector>

#include "src/domain/contracts/Irepository.hpp"

struct sqlite3;

namespace budgetpilot::domain::models {
    struct Transaction;
    struct Category;
}


namespace budgetpilot::infrastructure::repositories {
    class TransactionRepository final : public domain::contracts::IRepository<domain::models::Transaction> {
    public:
        explicit TransactionRepository(sqlite3 &connection);

        void add(const domain::models::Transaction &transaction) override;
        void update(const domain::models::Transaction &transaction) override;
        void remove(const std::uint64_t &id) override;

        [[nodiscard]]
        std::vector<domain::models::Transaction> getAll() override;

        [[nodiscard]]
        std::optional<domain::models::Transaction> getOne(const std::uint64_t &id) override;

    private:
        using TimePoint = std::chrono::system_clock::time_point;

        sqlite3 &connection_;
        static std::int64_t convert_to_seconds(TimePoint time_point);
        static std::chrono::system_clock::time_point from_unix(std::int64_t value);
    };
}
