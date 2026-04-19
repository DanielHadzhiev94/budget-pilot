#pragma once

#include <string>

namespace budgetpilot::domain::model {
    struct Account {
        std::uint64_t id{0};
        std::string name{};
        double amount{0.0};

        Account() {
            if (name.empty() != 1) {
                throw std::runtime_error("Name cannot be empty!");
            }
        }
    };
}
