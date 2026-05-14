#include "CategoryService.hpp"

#include<stdexcept>

#include "src/domain/contracts/IRepository.hpp"

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::application::services {
    CategoryService::CategoryService(domain::contracts::IRepository<models::Category> &category_repository)
        : category_repository_(category_repository) {
    }

    utilities::Response<std::vector<domain::models::Category> > CategoryService::load_category() const {
        try {
            const auto categories = category_repository_.getAll();
            return utilities::Response<std::vector<models::Category> >::Success(categories);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Category> >::Failed(
                std::string{"Failed to load category"} + ex.what()
            );
        }
    }
}
