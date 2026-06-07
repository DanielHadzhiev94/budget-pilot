#pragma once

#include <QObject>
#include <QVariantList>

#include <cstdint>
#include <string>

namespace budgetpilot::application::services {
    class TransactionService;
    class CategoryService;
}

namespace services = budgetpilot::application::services;

namespace budgetpilot::presentation::viewmodels {
    class RecentTransactionVm : public QObject {
        Q_OBJECT

        Q_PROPERTY(QVariantList transactions READ transactions NOTIFY transaction_changed)

    public:
        explicit RecentTransactionVm(
            services::TransactionService &transaction_service,
            services::CategoryService &category_service,
            QObject *parent = nullptr
        );

        [[nodiscard]]
        QVariantList transactions() const;

        Q_INVOKABLE void load_data(int month, int year);

    signals:
        void transaction_changed();

    private:
        QVariantList transactions_;
        services::TransactionService &transaction_service_;
        services::CategoryService &category_service_;

        int selected_month_{1};
        int selected_year_{1970};

        std::string get_category_name(std::int64_t id);
        void reload_data();
    };
}
