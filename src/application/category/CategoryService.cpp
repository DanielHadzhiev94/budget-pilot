#include "CategoryService.hpp"

#include<stdexcept>

#include "src/domain/contracts/IRepository.hpp"

namespace budgetpilot::application::category {
    namespace model = domain::model;
    namespace utilities = domain::utilities;

    CategoryService::CategoryService(domain::contracts::IRepository<model::Category> &category_repository)
        : category_repository_(category_repository) {
    }

    utilities::Response<std::vector<domain::model::Category> > CategoryService::load_category() const {
        try {
            const auto categories = category_repository_.getAll();
            return utilities::Response<std::vector<model::Category> >::Success(categories);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<model::Category> >::Failed(
                std::string{"Failed to load category"} + ex.what()
            );
        }
    }
}
