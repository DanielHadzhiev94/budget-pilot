#pragma once

#include <vector>

#include "src/domain/model/Category.hpp"
#include "src/domain/utilities/Response.hpp"


namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;
namespace contracts = budgetpilot::domain::contracts;

namespace budgetpilot::application::services {
    class CategoryService {
    public:
        explicit CategoryService(
            contracts::IRepository<models::Category> &category_repository
        );

        [[nodiscard]]
        utilities::Response<std::vector<models::Category> > load_category() const;

        [[nodiscard]]
        utilities::Response<models::Category> get_category(const std::int64_t id) const;

    private:
        contracts::IRepository<models::Category> &category_repository_;
    };
}
