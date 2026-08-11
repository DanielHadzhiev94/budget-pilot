#include "RecentTransactionVm.hpp"

#include <QDate>
#include <QDateTime>
#include <QMap>
#include <QVariantMap>

#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "src/domain/utilities/TimeConverter.hpp"

namespace utilities = budgetpilot::domain::utilities;

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

    QVariantList RecentTransactionVm::expenseCategoryTotals() const {
        return expense_category_totals_;
    }

    void RecentTransactionVm::load_data(int month, int year) {
        selected_month_ = month;
        selected_year_ = year;

        const auto transaction_response = transaction_service_.load_by_month(month, year, 15);
        QVariantList new_transactions;

        if (transaction_response.is_successful()) {
            for (const auto &transaction: transaction_response.data()) {
                QVariantMap row;
                const auto timestamp = utilities::TimeConverter::convert_to_seconds(
                    transaction.transaction_date);
                row["date"] = QDateTime::fromSecsSinceEpoch(timestamp)
                                  .date()
                                  .toString("yyyy-MM-dd");
                row["type"] = transaction.type == enums::Type::Income ? "Income" : "Expense";
                row["category"] = QString::fromStdString(get_category_name(static_cast<std::int64_t>(transaction.category_id)));
                row["source"] = QString::fromStdString(transaction.source.value_or(""));
                row["amount"] = transaction.amount;

                new_transactions.push_back(row);
            }
        }

        transactions_ = std::move(new_transactions);
        emit transaction_changed();

        // The dashboard preview needs the complete period, not the 15 items used
        // by the recent-activity list above.
        const auto expense_response = transaction_service_.load_expense(month, year);
        QMap<QString, double> category_totals;

        if (expense_response.is_successful()) {
            for (const auto &transaction : expense_response.data()) {
                const QString category = QString::fromStdString(
                    get_category_name(static_cast<std::int64_t>(transaction.category_id)));
                category_totals[category] += transaction.amount;
            }
        }

        QVariantList new_expense_category_totals;
        for (auto it = category_totals.cbegin(); it != category_totals.cend(); ++it) {
            QVariantMap category;
            category["name"] = it.key();
            category["amount"] = it.value();
            new_expense_category_totals.push_back(category);
        }

        std::sort(new_expense_category_totals.begin(), new_expense_category_totals.end(),
                  [](const QVariant &left, const QVariant &right) {
                      return left.toMap().value("amount").toDouble()
                          > right.toMap().value("amount").toDouble();
                  });
        expense_category_totals_ = std::move(new_expense_category_totals);
        emit expense_category_totals_changed();
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
