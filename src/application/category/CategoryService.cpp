#include "CategoryService.hpp"

#include <algorithm>
#include<stdexcept>

#include "src/domain/contracts/IRepository.hpp"
#include "src/domain/contracts/ITransactionRepository.hpp"

namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::application::services {
    CategoryService::CategoryService(
        domain::contracts::IRepository<models::Category> &category_repository,
        domain::contracts::ITransactionRepository &transaction_repository)
        : category_repository_(category_repository),
          transaction_repository_(transaction_repository) {
    }

    utilities::Response<void> CategoryService::delete_category(const std::uint64_t id) {
        try {
            const auto category = category_repository_.get_one(id);
            if (!category.has_value()) {
                return utilities::Response<void>::Failed(
                    std::string{"Category with id: "} + std::to_string(id) + " not found.");
            }

            const std::string fallback_name = category->type == enums::Type::Expense
                                                  ? "Other Expense"
                                                  : "Other Income";
            if (category->name == fallback_name) {
                return utilities::Response<void>::Failed(
                    fallback_name + " is the required default category and cannot be deleted.");
            }

            const auto categories = category_repository_.get_all();
            const auto fallback = std::find_if(
                categories.begin(),
                categories.end(),
                [&fallback_name, &category](const models::Category &candidate) {
                    return candidate.name == fallback_name && candidate.type == category->type;
                });
            if (fallback == categories.end()) {
                return utilities::Response<void>::Failed(
                    std::string{"Default category not found: "} + fallback_name);
            }

            transaction_repository_.replace_category_id(id, static_cast<std::uint64_t>(fallback->id));
            category_repository_.remove(id);
            return utilities::Response<void>::Success("Category deleted and transactions reassigned.");
        } catch (const std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Failed to delete category: "} + ex.what());
        }
    }

    utilities::Response<void> CategoryService::create_category(models::Category category) {
        try {
            category_repository_.add(category);
            return utilities::Response<void>::Success("Category created");
        } catch (const std::exception &ex) {
            return utilities::Response<void>::Failed(
                std::string{"Failed to create category: "} + ex.what()
            );
        }
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
