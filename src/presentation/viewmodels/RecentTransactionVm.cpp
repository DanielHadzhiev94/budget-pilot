#include "RecentTransactionVm.hpp"

#include <QDate>
#include <QVariantMap>

#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"

namespace budgetpilot::presentation::viewmodels {
    RecentTransactionVm::RecentTransactionVm(
        services::TransactionService &transaction_service,
        services::CategoryService &category_service,
        QObject *parent)
        : transaction_service_(transaction_service),
          category_service_(category_service) {
        const QDate today = QDate::currentDate();
        selected_month_ = today.month();
        selected_year_ = today.year();

        connect(&transaction_service_,
                &services::TransactionService::transaction_changed,
                this,
                &RecentTransactionVm::reload_data);
    }

    QVariantList RecentTransactionVm::transactions() const {
        return transactions_;
    }

    void RecentTransactionVm::load_data(int month, int year) {
        selected_month_ = month;
        selected_year_ = year;

        const auto transaction_response = transaction_service_.load_by_month(month, year, 15);
        QVariantList new_transactions;

        if (transaction_response.is_successful()) {
            for (const auto &transaction: transaction_response.data()) {
                QVariantMap row;
                row["date"] = QString::fromStdString(transaction.created_at);
                row["type"] = transaction.type == enums::Type::Income ? "Income" : "Expense";
                row["category"] = QString::fromStdString(get_category_name(static_cast<std::int64_t>(transaction.category_id)));
                row["source"] = QString::fromStdString(transaction.source.value_or(""));
                row["amount"] = transaction.amount;

                new_transactions.push_back(row);
            }
        }

        transactions_ = std::move(new_transactions);
        emit transaction_changed();
    }

    std::string RecentTransactionVm::get_category_name(const std::int64_t id) {
        const auto category_response = category_service_.get_category(id);
        std::string category{"unknown"};

        if (category_response.is_successful()) {
            category.assign(category_response.data().name);
        }

        return category;
    }

    void RecentTransactionVm::reload_data() {
        load_data(selected_month_, selected_year_);
    }
}
