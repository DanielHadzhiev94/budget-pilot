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

        if (index.row() < 0 || index.row() >= static_cast<int>(transactions_.size())) {
            return {};
        }

        const auto &transaction = transactions_[index.row()];

        if (role != Qt::DisplayRole) {
            return {};
        }

        switch (index.column()) {
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

            default:
                return {};
        }
    }

    QVariant TransactionTableVm::headerData(
        int section,
        Qt::Orientation orientation,
        int role
    ) const {
        if (orientation != Qt::Horizontal || role != Qt::DisplayRole) {
            return {};
        }

        switch (section) {
            case DateColumn:
                return "Date";

            case TypeColumn:
                return "Type";

            case CategoryColumn:
                return "Category";

            case SourceColumn:
                return "Source";

            case NoteColumn:
                return "Note";

            case AmountColumn:
                return "Amount";

            default:
                return {};
        }
    }

    void TransactionTableVm::loadMockData() {
        beginResetModel();

        transactions_.clear();

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
