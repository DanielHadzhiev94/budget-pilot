#include "TransactionTableVm.hpp"

namespace budgetpilot::presentation::viewmodels {

    TransactionTableVm::TransactionTableVm(QObject *parent)
        : QAbstractTableModel(parent) {
        loadMockData();
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

    void TransactionTableVm::loadMockData() {
        beginResetModel();

        transactions_ = {
            {"2026-05-17", "Expense", "Food", "Lidl", "Text", 24.50},
            {"2026-05-16", "Income", "Salary", "Company", "Text", 3200.00},
            {"2026-05-15", "Expense", "Transport", "DB Ticket", "Text", 49.90},
            {"2026-05-14", "Expense", "Shopping", "Amazon", "Text", 89.99},
            {"2026-05-13", "Expense", "Apartment", "Rent", "Text", 950.00}
        };

        endResetModel();
    }

}