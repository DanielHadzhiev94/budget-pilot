#pragma once

#include <QAbstractTableModel>
#include <QString>

#include <cstdint>
#include <string>
#include <vector>

namespace budgetpilot::application::services {
    class TransactionService;
    class CategoryService;
}

namespace services = budgetpilot::application::services;

namespace budgetpilot::presentation::viewmodels {
    class TransactionTableVm final : public QAbstractTableModel {
        Q_OBJECT

    public:
        explicit TransactionTableVm(
            services::TransactionService &transaction_service,
            services::CategoryService &category_service,
            QObject *parent = nullptr
        );

        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        int columnCount(const QModelIndex &parent = QModelIndex()) const override;

        QVariant data(
            const QModelIndex &index,
            int role = Qt::DisplayRole
        ) const override;

        Q_INVOKABLE void loadData(int month, int year);
        Q_INVOKABLE void deleteTransaction(int row);
        Q_INVOKABLE void setDate(int month, int year);

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
            std::int64_t id;
            QString date;
            QString type;
            QString category;
            QString source;
            QString note;
            double amount = 0.0;
        };

        QString formatDate(std::int64_t timestamp) const;
        QString getCategoryName(std::int64_t id) const;

        int selected_month;
        int selected_year;

        std::vector<TransactionRow> transactions_;

        services::TransactionService &transaction_service_;
        services::CategoryService &category_service_;

        void reload();
    };
}
