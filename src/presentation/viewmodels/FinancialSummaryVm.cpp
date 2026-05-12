#include <iostream>

#include "FinancialSummaryVm.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "src/application/account/AccountsService.hpp"

namespace services = budgetpilot::application::services;
namespace models = budgetpilot::domain::models;

namespace budgetpilot::presentation::viewmodels {
    FinancialSummaryVm::FinancialSummaryVm(services::TransactionService &transaction_service,
                                           services::AccountService &account_service,
                                           QObject *parent)
        : transaction_service_(transaction_service),
          account_service_(account_service) {
        //Test
        load_data(0, 0);

        connect(
            &transaction_service_,
            &services::TransactionService::transaction_created,
            this,
            &FinancialSummaryVm::reload_data);
    }

    double FinancialSummaryVm::current_balance() const {
        return current_balance_;
    }

    double FinancialSummaryVm::income() const {
        return income_;
    }

    double FinancialSummaryVm::expense() const {
        return expense_;
    }

    void FinancialSummaryVm::create_transaction(const models::Transaction &transaction) {
        const auto response = transaction_service_.create_transaction(transaction);
        // TODO: Add Toast to show the response on the UI
        std::cout << response.message() << std::endl;
    }

    void FinancialSummaryVm::load_data(int month, int year) {
        // Test
        const auto account_response = account_service_.load_accounts();
        if (account_response.is_successful())
            current_balance_ = 0.0f;
        for (const auto &acc: account_response.data()) {
            current_balance_ += acc.amount;
        }

        emit current_balance_changed();
    }

    void FinancialSummaryVm::reload_data() {
        load_data(0, 0);
    }
}
