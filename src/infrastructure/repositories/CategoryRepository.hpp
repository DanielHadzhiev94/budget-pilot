#pragma once

#include <cstdint>
#include <sqlite3.h>
#include <optional>

#include "../../domain/contracts/IRepository.hpp"

namespace budgetpilot::domain::models {
    struct Category;
}

namespace budgetpilot::infrastructure::repositories {
    class CategoryRepository : public domain::contracts::IRepository<domain::models::Category> {
    public:
        explicit CategoryRepository(sqlite3 &db);

        void add(const domain::models::Category &entity) override;
        void update(const domain::models::Category &entity) override;
        void remove(const std::uint64_t &id) override;

        [[nodiscard]]
        std::vector<domain::models::Category> getAll() override;

        [[nodiscard]]
        std::optional<domain::models::Category> getOne(const std::uint64_t &id) override;

    private:
        sqlite3 &connection_;
    };
}
