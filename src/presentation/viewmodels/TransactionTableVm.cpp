#include "TransactionTableVm.hpp"

#include <qmap.h>
#include<qvariant.h>

#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"

namespace budgetpilot::presentation::viewmodels {
    TransactionTableVm::TransactionTableVm(services::TransactionService &transaction_service,
                                           services::CategoryService &category_service,
                                           QObject *parent)
        : transaction_service_(transaction_service),
          category_service_(category_service) {
        connect(&transaction_service_,
                &services::TransactionService::transaction_created,
                this,
                &TransactionTableVm::reload_data);

        load_data(5, 2026);
    }

    QVariantList TransactionTableVm::transactions() const {
        return transactions_;
    }

    void TransactionTableVm::load_data(int month, int year) {
        const auto &transaction_response = transaction_service_.load_all_by_month(month, year);
        transactions_.clear();

        if (transaction_response.is_successful()) {
            QVariantList new_transactions;

            for (const auto &transaction: transaction_response.data()) {
                QVariantMap row;

                row["date"] = QString::fromStdString(transaction.created_at);
                row["type"] = transaction.type == enums::Type::Income ? "Income" : "Expense";
                row["category"] = QString::fromStdString(get_category_name(transaction.category_id));
                row["source"] = QString::fromStdString(transaction.source.value());
                row["amount"] = transaction.amount;

                new_transactions.push_back(row);
            }
            transactions_.append(std::move(new_transactions));
        }

        emit transaction_changed();
    }

    std::string TransactionTableVm::get_category_name(const std::int64_t id) {
        const auto &category_response = category_service_.get_category(id);
        std::string category{"unknown"};

        if (category_response.is_successful())
            category.assign(category_response.data().name);

        return category;
    }

    void TransactionTableVm::reload_data() {
        load_data(5, 2026);
    }
}
