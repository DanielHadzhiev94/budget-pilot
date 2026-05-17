#pragma once

#include <cstdint>

namespace budgetpilot::domain::models::enums {
    enum class Type : std::uint8_t {
        Income = 1,
        Expense = 2
    };
}
