#pragma once

#include <vector>

namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository {
    public:
        virtual ~IRepository() = default;

        virtual void add(const T &entity) = 0;
        virtual void update(const T &entity) = 0;
        virtual void remove(const std::uint64_t &id) = 0;

        virtual std::vector<T> getAll(int month, int year) = 0;
        virtual std::optional<T> getOne(const std::uint64_t &id) = 0;
    };
};
