#pragma once

#include <vector>

#include "src/domain/models/Category.hpp"
#include "src/domain/utilities/Response.hpp"


namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;

    class ITransactionRepository;
}

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services {
    class CategoryService {
    public:
        explicit CategoryService(
            contracts::IRepository<models::Category> &category_repository,
            contracts::ITransactionRepository &transaction_repository
        );

        [[nodiscard]]
        utilities::Response<void> create_category(models::Category category);

        [[nodiscard]]
        utilities::Response<void> delete_category(std::uint64_t id);

        [[nodiscard]]
        utilities::Response<std::vector<models::Category> > load_category() const;

        [[nodiscard]]
        utilities::Response<models::Category> get_category(const std::int64_t id) const;

    private:
        contracts::IRepository<models::Category> &category_repository_;
        contracts::ITransactionRepository &transaction_repository_;
    };
}
