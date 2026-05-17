#pragma once

#include <string>
#include <cstdint>

#include "../../domain/models/Enums.hpp"

namespace budgetpilot::domain::models {
    struct Category {
        std::int64_t id;
        std::string name;
        std::string created_at;
        enums::Type type;

        Category() = default;

        Category(const std::string name)
            : name(name) {
        }
    };
}
