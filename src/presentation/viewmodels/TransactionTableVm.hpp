#pragma once

#pragma once

#include <QAbstractTableModel>
#include <QString>
#include <vector>

namespace budgetpilot::presentation::viewmodels {
    struct TransactionTableRow {
        QString date;
        QString type;
        QString category;
        QString source;
        QString note;
        double amount{};
        QString actions;
    };

    class TransactionTableVm : public QAbstractTableModel {
        Q_OBJECT

    public:
        enum Column {
            DateColumn = 0,
            TypeColumn,
            CategoryColumn,
            SourceColumn,
            NoteColumn,
            AmountColumn,
            ActionsColumn,
            ColumnCount
        };

        explicit TransactionTableVm(QObject *parent = nullptr);

        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        int columnCount(const QModelIndex &parent = QModelIndex()) const override;

        QVariant data(
            const QModelIndex &index,
            int role = Qt::DisplayRole
        ) const override;

        QVariant headerData(
            int section,
            Qt::Orientation orientation,
            int role = Qt::DisplayRole
        ) const override;

        Q_INVOKABLE void loadMockData();

    private:
        std::vector<TransactionTableRow> transactions_;
    };
}
