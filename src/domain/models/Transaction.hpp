#pragma once

#include <string>
#include <chrono>
#include <optional>
#include <cstdint>
#include <stdexcept>
#include <string>
#include <cstdint>

#include "Enums.hpp"

namespace enums = budgetpilot::domain::models::enums;

namespace budgetpilot::domain::models {
    using TimePoint = std::chrono::system_clock::time_point;

    struct Transaction {
        std::uint64_t id{0};

        std::uint64_t account_id{0};
        std::uint64_t category_id{0};

        enums::Type type{enums::Type::Income};

        double amount{0.0};

        std::optional<std::string> source{};
        std::optional<std::string> note{};

        TimePoint transaction_date{};
        std::string created_at{};

        Transaction() = default;

        Transaction(
            std::int64_t accountId,
            std::int64_t categoryId,
            enums::Type t,
            double amt,
            TimePoint txDate,
            std::optional<std::string> src = std::nullopt,
            std::optional<std::string> n = std::nullopt
        )
            : account_id(accountId),
              category_id(categoryId),
              type(t),
              amount(amt),
              source(std::move(src)),
              note(std::move(n)),
              transaction_date(txDate) {
            // basic invariant
            if (amount <= 0.0) {
                throw std::invalid_argument("Transaction amount must be > 0");
            }
        }
    };
}
