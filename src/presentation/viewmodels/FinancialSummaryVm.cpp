#include "FinancialSummaryVm.hpp"

#include <iostream>

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

    void FinancialSummaryVm::add_income() {
        current_balance_ += 100;
        emit current_balance_changed();
    }

    void FinancialSummaryVm::load_data(int month, int year) {
        std::cout << month << year << "\n";
    }
}
