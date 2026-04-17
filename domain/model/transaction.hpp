#pragma once
#include <string>

namespace budgetpilot::domain::model {
    enum class Type : std::uint8_t {
        INCOME = 1,
        EXPENSE = 2
    };

    struct Transaction {
        std::string source = "-";
        Type type = Type::INCOME;
        float amount;
        std::int64_t category_id;
    };
}