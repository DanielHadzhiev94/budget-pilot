#pragma once

#include <string>

namespace budgetpilot::domain::model {
    struct Account {
        std::uint64_t id{0};
        std::string name{};
        double amount{0.0};
        std::string created_at;

        Account() = default;

        Account(const std::string &name, double amount)
            : name(name), amount(amount) {
            if (name.empty() == 1) {
                throw std::runtime_error("Name cannot be empty!");
            }
            if (amount < 0) {
                throw std::runtime_error("Balance cannot be negative");
            }
        };
    };
}
