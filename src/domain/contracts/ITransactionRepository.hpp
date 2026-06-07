#pragma once
#include "IRepository.hpp"
#include "src/domain/models/Transaction.hpp"

namespace budgetpilot::domain::contracts
{
    class ITransactionRepository : public IRepository<models::Transaction>
    {
    public:
        virtual ~ITransactionRepository() = default;

        virtual std::vector<models::Transaction> get_all_by_month(int month, int year) = 0;
        virtual std::vector<models::Transaction> get_by_month(int month, int year, int limit) = 0;
        virtual double get_balance_by_account_id(int account_id) = 0;
        virtual std::vector<models::Transaction> get_all_by_month_and_type(int month, int year, enums::Type type) = 0;
        virtual std::vector<models::Transaction> get_by_date_and_account_id(int month, int year, int account_id) = 0;
    };
}
