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
        connect(
            &transaction_service_,
            &services::TransactionService::transaction_created,
            this,
            &FinancialSummaryVm::reload_data);
    }

    double FinancialSummaryVm::current_balance() const {
        return current_balance_;
    }

    void FinancialSummaryVm::set_current_balance(double value) {
        current_balance_ = value;
    }

    double FinancialSummaryVm::income() const {
        return income_;
    }

    void FinancialSummaryVm::set_income(double value) {
        income_ = value;
    }

    double FinancialSummaryVm::expense() const {
        return expense_;
    }

    void FinancialSummaryVm::set_expense(double value) {
        expense_ = value;
    }

    double FinancialSummaryVm::saving_rate() const {
        return saving_rate_;
    }

    void FinancialSummaryVm::set_saving_rate(double value) {
        saving_rate_ = value;
    }

    void FinancialSummaryVm::create_transaction(const models::Transaction &transaction) {
        const auto response = transaction_service_.create_transaction(transaction);
        // TODO: Add Toast to show the response on the UI
        std::cout << response.message() << std::endl;
    }

    void FinancialSummaryVm::load_data(int month, int year) {
        load_account_data();
        load_income_data(month, year);
        load_expense_data(month, year);
        load_saving_rate(month, year);
    }

    void FinancialSummaryVm::set_date(int month, int year) {
        selected_month_ = month;
        selected_year_ = year;
    }

    void FinancialSummaryVm::load_account_data() {
        const auto account_response = account_service_.load_accounts();
        if (account_response.is_successful())
            current_balance_ = 0.0f;
        for (const auto &acc: account_response.data()) {
            current_balance_ += acc.amount;
        }

        emit current_balance_changed();
    }

    void FinancialSummaryVm::load_income_data(int month, int year) {
        const auto &transaction_response = transaction_service_.load_income_data(month, year);
        if (transaction_response.is_successful()) {
            set_income(0);

            double income_sum = 0;
            for (const auto &income: transaction_response.data()) {
                income_sum += income.amount;
            }

            set_income(income_sum);
            emit income_changed();
        }
    }

    void FinancialSummaryVm::load_expense_data(int month, int year) {
        const auto &expense_response = transaction_service_.load_expense_data(month, year);
        if (expense_response.is_successful()) {
            set_expense(0);
            double expense_sum = 0;
            for (const auto &expense: expense_response.data()) {
                expense_sum += expense.amount;
            }

            set_expense(expense_sum);
            emit expense_changed();
        }
    }

    void FinancialSummaryVm::load_saving_rate(int month, int year) {
        const auto &saving_rate_response = transaction_service_.calculate_monthly_saving_rate(month, year);
        if (saving_rate_response.is_successful()) {
            set_saving_rate(saving_rate_response.data());
            emit saving_rate_changed();
        }
    }

    void FinancialSummaryVm::reload_data() {
        load_data(selected_month_, selected_year_);
        std::cout << selected_month_ << " - " << selected_year_ << std::endl;
    }
}
