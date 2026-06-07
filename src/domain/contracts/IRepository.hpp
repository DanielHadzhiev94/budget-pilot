#pragma once

#include <cstdint>
#include <optional>
#include <vector>

namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository {
    public:
        virtual ~IRepository() = default;

        virtual void add(const T &entity) = 0;
        virtual void update(const T &entity) = 0;
        virtual void remove(const std::uint64_t &id) = 0;

        virtual std::vector<T> get_all() = 0;
        virtual std::optional<T> get_one(const std::uint64_t &id) = 0;
    };
}
