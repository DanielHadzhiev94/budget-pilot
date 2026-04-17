#pragma once
#include <string>

namespace budgetpilot::domain::model {
    enum class Type : std::uint8_t {
        INCOME = 1,
        EXPENSE = 2
    };

    struct Transaction {
        std::int64_t id = 0;
        std::string source = "-";
        Type type = Type::INCOME;
        float amount;
        std::int64_t category_id;

        Transaction() = default;

        Transaction(std::string source,
                    Type type,
                    float amount,
                    std::int64_t category_id)
            : source(std::move(source)),
              type(type),
              amount(amount),
              category_id(category_id) {
        }
    };
}
