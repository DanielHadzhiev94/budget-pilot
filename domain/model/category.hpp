#pragma once
#include <string>

namespace budgetpilot::domain::model {
    struct Category {
        std::int64_t id;
        std::string name;
    };
}
