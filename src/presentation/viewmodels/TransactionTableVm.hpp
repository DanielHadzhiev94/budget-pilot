#pragma once

#include <QAbstractTableModel>
#include <QString>
#include <vector>

namespace budgetpilot::presentation::viewmodels {

    class TransactionTableVm final : public QAbstractTableModel {
        Q_OBJECT

    public:
        explicit TransactionTableVm(QObject *parent = nullptr);

        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        int columnCount(const QModelIndex &parent = QModelIndex()) const override;

        QVariant data(
            const QModelIndex &index,
            int role = Qt::DisplayRole
        ) const override;

    private:
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

        struct TransactionRow {
            QString date;
            QString type;
            QString category;
            QString source;
            QString note;
            double amount = 0.0;
        };

        void loadMockData();

    private:
        std::vector<TransactionRow> transactions_;
    };

}