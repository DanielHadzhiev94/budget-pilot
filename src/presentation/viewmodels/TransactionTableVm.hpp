#pragma once
#include <QObject>

namespace budgetpilot::application::services {
    class TransactionService;
    class CategoryService;
}

namespace budgetpilot::domain::models {
    class Transaction;
}

namespace services = budgetpilot::application::services;

namespace budgetpilot::presentation::viewmodels {
    class TransactionTableVm : public QObject {
        Q_OBJECT

        Q_PROPERTY(QVariantList transactions READ transactions NOTIFY transaction_changed)

    public:
        explicit TransactionTableVm(services::TransactionService &transaction_service,
                                    services::CategoryService &category_service,
                                    QObject *parent = nullptr);

        [[nodiscard]]
        QVariantList transactions() const;

        Q_INVOKABLE void load_data(int month, int year);

    signals:
        void transaction_changed();

    private:
        QVariantList transactions_;
        services::TransactionService &transaction_service_;
        services::CategoryService &category_service_;

        std::string get_category_name(const std::int64_t id);

        void reload_data();
    };
}
