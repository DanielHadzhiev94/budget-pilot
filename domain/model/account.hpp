#pragma once

#include <string>

namespace budgetpilot::domain::model {
    struct Account {
        std::uint64_t id{0};
        std::string name{};

        Account() {
            if (name.empty() != 1) {
                throw std::runtime_error("Name cannot be empty!");
            }
        }
    };
}
