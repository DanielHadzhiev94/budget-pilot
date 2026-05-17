#pragma once
#include "IRepository.hpp"
#include "src/domain/models/Transaction.hpp"


namespace budgetpilot::domain::contracts {
    class ITransactionRepository : public IRepository<models::Transaction> {
    public:
        virtual ~ITransactionRepository() = default;

        virtual std::vector<models::Transaction> get_all_by_month(int month, int year) = 0;
        virtual std::vector<models::Transaction> get_all_by_month_and_type(int month, int year, enums::Type type) = 0;
    };
}
