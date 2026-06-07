#include "TransactionTableVm.hpp"

#include <iostream>

#include <QDate>
#include <QDateTime>
#include <QVariantMap>

#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "src/domain/utilities/TimeConverter.hpp"

namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::presentation::viewmodels {
    TransactionTableVm::TransactionTableVm(
        services::TransactionService &transaction_service,
        services::CategoryService &category_service,
        QObject *parent
    )
        : QAbstractTableModel(parent),
          transaction_service_(transaction_service),
          category_service_(category_service) {
        const QDate today = QDate::currentDate();
        loadData(today.month(), today.year());

        connect(
            &transaction_service_,
            &services::TransactionService::transaction_changed,
            this,
            &TransactionTableVm::reload
        );
    }

    int TransactionTableVm::rowCount(const QModelIndex &parent) const {
        if (parent.isValid()) {
            return 0;
        }

        return static_cast<int>(transactions_.size());
    }

    int TransactionTableVm::columnCount(const QModelIndex &parent) const {
        if (parent.isValid()) {
            return 0;
        }

        return ColumnCount;
    }

    QVariant TransactionTableVm::data(const QModelIndex &index, int role) const {
        if (!index.isValid() || role != Qt::DisplayRole) {
            return {};
        }

        const int row = index.row();
        const int column = index.column();

        if (row < 0 || row >= static_cast<int>(transactions_.size())) {
            return {};
        }

        const auto &transaction = transactions_[row];

        switch (column) {
            case DateColumn:
                return transaction.date;
            case TypeColumn:
                return transaction.type;
            case CategoryColumn:
                return transaction.category;
            case SourceColumn:
                return transaction.source;
            case NoteColumn:
                return transaction.note;
            case AmountColumn:
                return transaction.amount;
            case ActionsColumn:
            default:
                return {};
        }
    }

    void TransactionTableVm::setDate(int month, int year) {
        selected_month = month;
        selected_year = year;
    }

    void TransactionTableVm::loadData(int month, int year) {
        setDate(month, year);
        beginResetModel();
        transactions_.clear();

        const auto transaction_response = transaction_service_.load_all_by_month(month, year);

        if (transaction_response.is_successful()) {
            for (const auto &transaction: transaction_response.data()) {
                TransactionRow row;
                row.id = transaction.id;
                row.account_id = transaction.account_id;
                row.category_id = transaction.category_id;
                row.date = formatDate(utilities::TimeConverter::convert_to_seconds(transaction.transaction_date));
                row.type = transaction.type == decltype(transaction.type)::Income ? "Income" : "Expense";
                row.category = getCategoryName(static_cast<std::int64_t>(transaction.category_id));
                row.source = QString::fromStdString(transaction.source.value_or(""));
                row.note = QString::fromStdString(transaction.note.value_or(""));
                row.amount = transaction.amount;

                transactions_.push_back(std::move(row));
            }
        }

        endResetModel();
    }

    void TransactionTableVm::deleteTransaction(int row) {
        if (row < 0 || row >= static_cast<int>(transactions_.size())) {
            return;
        }

        const auto transaction_id = transactions_[row].id;
        const auto response = transaction_service_.delete_transaction(transaction_id);
        std::cout << response.message() << "\n";
    }

    QString TransactionTableVm::formatDate(std::int64_t timestamp) {
        const QDateTime dateTime = QDateTime::fromSecsSinceEpoch(timestamp);
        return dateTime.date().toString("yyyy-MM-dd");
    }

    QString TransactionTableVm::getCategoryName(std::int64_t id) const {
        const auto category_response = category_service_.get_category(id);
        std::string category{"unknown"};

        if (category_response.is_successful()) {
            category.assign(category_response.data().name);
        }

        return QString::fromStdString(category);
    }

    void TransactionTableVm::reload() {
        loadData(selected_month, selected_year);
    }

    QVariantMap TransactionTableVm::transactionAt(int row) const {
        QVariantMap map;

        if (row < 0 || row >= static_cast<int>(transactions_.size())) {
            return map;
        }

        const auto &transaction = transactions_[row];

        map["id"] = static_cast<qlonglong>(transaction.id);
        map["accountId"] = static_cast<qlonglong>(transaction.account_id);
        map["categoryId"] = static_cast<qlonglong>(transaction.category_id);
        map["date"] = transaction.date;
        map["type"] = transaction.type;
        map["category"] = transaction.category;
        map["source"] = transaction.source;
        map["note"] = transaction.note;
        map["amount"] = transaction.amount;

        return map;
    }
}
