#pragma once

#include <chrono>
#include <optional>
#include <vector>

#include "src/domain/contracts/Irepository.hpp"
#include "src/domain/contracts/ITransactionRepository.hpp"
#include "src/domain/model/Transaction.hpp"

struct sqlite3;

namespace budgetpilot::domain::models {
    struct Transaction;
    struct Category;
}

namespace budgetpilot::infrastructure::persistence {
    class Statement;
}

namespace models = budgetpilot::domain::models;

namespace budgetpilot::infrastructure::repositories {
    class TransactionRepository final : public domain::contracts::ITransactionRepository {
    public:
        explicit TransactionRepository(sqlite3 &connection);

        void add(const models::Transaction &transaction) override;
        void update(const models::Transaction &transaction) override;
        void remove(const std::uint64_t &id) override;

        [[nodiscard]]
        std::vector<models::Transaction> getAll() override;

        [[nodiscard]]
        std::optional<models::Transaction> getOne(const std::uint64_t &id) override;

        [[nodiscard]]
        std::vector<models::Transaction> getAllByMonth(int month, int year) override;

        [[nodiscard]]
        std::vector<models::Transaction> getAllByMonthAndType(int month, int year, enums::Type type) override;

    private:
        using TimePoint = std::chrono::system_clock::time_point;

        sqlite3 &connection_;
        static models::Transaction build_transaction_(const persistence::Statement &stmt);
    };
}
