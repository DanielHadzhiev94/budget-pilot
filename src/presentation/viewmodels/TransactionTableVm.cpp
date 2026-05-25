#include "TransactionTableVm.hpp"

#include <iostream>
#include <QDateTime>
#include <QDate>

#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"

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

    QVariant TransactionTableVm::data(
        const QModelIndex &index,
        int role
    ) const {
        if (!index.isValid()) {
            return {};
        }

        if (role != Qt::DisplayRole) {
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
                return {};

            default:
                return {};
        }
    }

    void TransactionTableVm::loadData(int month, int year) {
        beginResetModel();

        transactions_.clear();

        const auto transaction_response = transaction_service_.load_all_by_month(month, year);

        if (!transaction_response.is_successful()) {
            return;
        }

        for (const auto &transaction: transaction_response.data()) {
            TransactionRow row;
            row.id = transaction.id;
            row.date = QString::fromStdString(transaction.created_at);

            row.type = transaction.type == decltype(transaction.type)::Income
                           ? "Income"
                           : "Expense";

            row.category = getCategoryName(transaction.category_id);

            row.source = QString::fromStdString(transaction.source.value());
            row.note = QString::fromStdString(transaction.note.value());
            row.amount = static_cast<double>(transaction.amount);

            transactions_.push_back(row);
        }

        endResetModel();
    }

    void TransactionTableVm::deleteTransaction(int row) {
        if (row < 0 || row >= static_cast<int>(transactions_.size()))
            return;

        const auto transactionRow = transactions_[row];

        //TODO: Add toas for succesful message
        const auto response = transaction_service_.delete_transaction(transactionRow.id);
        std::cout << response.message() << "\n";
    }

    QString TransactionTableVm::formatDate(std::int64_t timestamp) const {
        const QDateTime dateTime = QDateTime::fromSecsSinceEpoch(timestamp);
        return dateTime.date().toString("yyyy-MM-dd");
    }

    QString TransactionTableVm::getCategoryName(std::int64_t id) const {
        const auto &category_response = category_service_.get_category(id);
        std::string category{"unknown"};

        if (category_response.is_successful())
            category.assign(category_response.data().name);

        return QString::fromStdString(category);
    }
}
