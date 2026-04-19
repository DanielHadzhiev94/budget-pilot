#include "account_repository.hpp"

using namespace budgetpilot::domain::model;

namespace budgetpilot::infrastructure::repositories {
    AccountRepository::AccountRepository(sqlite3 *connection) : connection_(connection) {
        if (!connection_) {
            throw std::invalid_argument("Database connection cannot be null.");
        }
    }
}
