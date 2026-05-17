#pragma once

#include <cstdint>
#include <sqlite3.h>
#include <optional>
#include <vector>

#include "../../domain/contracts/IRepository.hpp"
#include "../../domain/models/Account.hpp"

namespace models = budgetpilot::domain::models;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::infrastructure::repositories {
    class AccountRepository : public contracts::IRepository<models::Account> {
    public:
        explicit AccountRepository(sqlite3 &connection);

        void add(const models::Account &entity) override;
        void update(const models::Account &entity) override;
        void remove(const std::uint64_t &id) override;

        [[nodiscard]]
        std::vector<models::Account> get_all() override;

        [[nodiscard]]
        std::optional<models::Account> get_one(const std::uint64_t &id) override;

    private:
        sqlite3 &connection_;
    };
}
