#pragma once
#include <string>

namespace budgetpilot::domain::model {
    struct Category {
        std::int64_t id;
        std::string name;
        std::string created_at;

        Category() = default;

        Category(const std::string name)
            : name(name) {
        }
    };
}
