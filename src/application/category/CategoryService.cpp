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
            const auto categories = category_repository_.get_all();
            return utilities::Response<std::vector<models::Category> >::Success(categories);
        } catch (std::exception &ex) {
            return utilities::Response<std::vector<models::Category> >::Failed(
                std::string{"Failed to load category "} + ex.what()
            );
        }
    }

    utilities::Response<models::Category> CategoryService::get_category(const std::int64_t id) const {
        try {
            const auto opt_category = category_repository_.get_one(id);
            if (!opt_category.has_value())
                return utilities::Response<models::Category>::Failed(
                    std::string{"Category with id "}
                    + std::to_string(id)
                    + "not found!"
                );

            return utilities::Response<models::Category>::Success(opt_category.value());
        } catch (std::exception &ex) {
            return utilities::Response<models::Category>::Failed(
                std::string{"Failed to get category "} + ex.what()
            );
        }
    }
}
