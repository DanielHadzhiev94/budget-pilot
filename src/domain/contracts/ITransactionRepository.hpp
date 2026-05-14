#pragma once
#include "IRepository.hpp"
#include "src/domain/model/Transaction.hpp"


namespace budgetpilot::domain::contracts {
    class ITransactionRepository : public IRepository<models::Transaction> {
    public:
        virtual ~ITransactionRepository() = default;

        virtual std::vector<models::Transaction> getAllByMonth(int month, int year) = 0;
        virtual std::vector<models::Transaction> getAllByMonthAndType(int month, int year, enums::Type type) = 0;
    };
}
