#include <iostream>
#include <QDate>

#include "FinancialSummaryVm.hpp"
#include "../../application/transaction/TransactionService.hpp"
#include "../../application/account/AccountsService.hpp"

namespace services = budgetpilot::application::services;
namespace models = budgetpilot::domain::models;

namespace budgetpilot::presentation::viewmodels
{
    FinancialSummaryVm::FinancialSummaryVm(services::TransactionService &transaction_service,
                                           services::AccountService &account_service,
                                           QObject *parent)
        : QObject(parent),
          transaction_service_(transaction_service),
          account_service_(account_service)
    {
        const QDate today = QDate::currentDate();
        selected_month_ = today.month();
        selected_year_ = today.year();

        connect(
            &transaction_service_,
            &services::TransactionService::transaction_changed,
            this,
            &FinancialSummaryVm::reload_data);
    }

    double FinancialSummaryVm::current_balance() const
    {
        return current_balance_;
    }

    QVariantList FinancialSummaryVm::accounts() const
    {
        return accounts_;
    }

    void FinancialSummaryVm::set_current_balance(double value)
    {
        if (current_balance_ == value)
        {
            return;
        }

        current_balance_ = value;
    }

    double FinancialSummaryVm::income() const
    {
        return income_;
    }

    void FinancialSummaryVm::set_income(double value)
    {
        income_ = value;
    }

    double FinancialSummaryVm::expense() const
    {
        return expense_;
    }

    void FinancialSummaryVm::set_expense(double value)
    {
        expense_ = value;
    }

    double FinancialSummaryVm::saving_rate() const
    {
        return saving_rate_;
    }

    void FinancialSummaryVm::set_saving_rate(double value)
    {
        saving_rate_ = value;
    }

    void FinancialSummaryVm::create_transaction(const models::Transaction &transaction)
    {
        const auto response = transaction_service_.create_transaction(transaction);
        // TODO: Add Toast to show the response on the UI
        std::cout << response.message() << std::endl;
    }

    void FinancialSummaryVm::load_data(int month, int year)
    {
        load_account_data();
        load_income_data(month, year);
        load_expense_data(month, year);
        load_saving_rate(month, year);
    }

    void FinancialSummaryVm::set_date(int month, int year)
    {
        selected_month_ = month;
        selected_year_ = year;
    }

    void FinancialSummaryVm::load_account_data()
    {
        const auto account_response = account_service_.load_accounts();
        double total_balance = 0.0;
        QVariantList accounts;

        if (account_response.is_successful())
        {
            for (const auto &acc : account_response.data())
            {
                total_balance += acc.amount;

                QVariantMap account;
                account["id"] = static_cast<qlonglong>(acc.id);
                account["name"] = QString::fromStdString(acc.name);
                account["balance"] = acc.amount;
                accounts.append(account);
            }
        }

        set_current_balance(total_balance);
        accounts_ = std::move(accounts);

        emit current_balance_changed();
        emit accounts_changed();
    }

    void FinancialSummaryVm::load_income_data(int month, int year)
    {
        const auto &transaction_response = transaction_service_.load_income(month, year);
        set_income(0);
        if (transaction_response.is_successful())
        {
            double income_sum = 0;
            for (const auto &income : transaction_response.data())
            {
                income_sum += income.amount;
            }

            set_income(income_sum);
        }
        emit income_changed();
    }

    void FinancialSummaryVm::load_expense_data(int month, int year)
    {
        const auto &expense_response = transaction_service_.load_expense(month, year);
        set_expense(0);
        if (expense_response.is_successful())
        {
            double expense_sum = 0;
            for (const auto &expense : expense_response.data())
            {
                expense_sum += expense.amount;
            }

            set_expense(expense_sum);
        }
        emit expense_changed();
    }

    void FinancialSummaryVm::load_saving_rate(int month, int year)
    {
        const auto &saving_rate_response = transaction_service_.calculate_monthly_saving_rate(month, year);
        set_saving_rate(0);
        if (saving_rate_response.is_successful())
        {
            set_saving_rate(saving_rate_response.data());
        }
        emit saving_rate_changed();
    }

    void FinancialSummaryVm::reload_data()
    {
        load_data(selected_month_, selected_year_);
    }
}
