#pragma once
#include <vector>

namespace budgetpilot::domain::interface {
    template<typename T>
    class IRepository {
    public:
        virtual void add(T entity) = 0;
        virtual void update(T entity) = 0;
        virtual void remove(T entity) = 0;

        virtual std::vector<T> getAll() = 0;
        virtual T getOne(std::uint64_t id) = 0;
    };
};
