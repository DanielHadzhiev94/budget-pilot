#include <iostream>
#include "FinancialSummaryVm.hpp"
#include "src/application/transaction/TransactionService.hpp"

namespace budgetpilot::presentation::viewmodels {
    FinancialSummaryVm::FinancialSummaryVm(application::transaction::TransactionService *transaction_service,
                                           QObject *parent) : transaction_service_(transaction_service) {
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

    void FinancialSummaryVm::create_transaction(const Transaction &transaction) const {
        const auto response = transaction_service_->create_transaction(transaction);
        // TODO: Add Toast to show the response on the UI
        std::cout << response.message() << std::endl;
    }

    void FinancialSummaryVm::load_data(int month, int year) {
        std::cout << month << "-" << year << "\n";
    }
}
