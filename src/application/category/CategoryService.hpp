#pragma once

#include <vector>
#include "src/domain/model/Category.hpp"
#include "src/domain/utilities/Response.hpp"


namespace budgetpilot::domain::contracts {
    template<typename T>
    class IRepository;
}

namespace budgetpilot::application::category {
    class CategoryService {
    public:
        explicit CategoryService(
            domain::contracts::IRepository<domain::model::Category> &category_repository
        );

        [[nodiscard]]
        domain::utilities::Response<std::vector<domain::model::Category> > load_category() const;

    private:
        domain::contracts::IRepository<domain::model::Category> &category_repository_;
    };
}
