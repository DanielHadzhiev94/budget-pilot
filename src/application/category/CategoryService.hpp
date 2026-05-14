#pragma once

#include <vector>

#include "src/domain/model/Category.hpp"
#include "src/domain/utilities/Response.hpp"


namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace models = budgetpilot::domain::models;

namespace budgetpilot::application::services {
    class CategoryService {
    public:
        explicit CategoryService(
            domain::contracts::IRepository<models::Category> &category_repository
        );

        [[nodiscard]]
        domain::utilities::Response<std::vector<models::Category> > load_category() const;

    private:
        domain::contracts::IRepository<models::Category> &category_repository_;
    };
}
