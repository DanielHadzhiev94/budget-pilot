#pragma once

#include <QDebug>
#include <QObject>
#include <QString>
#include <QVariantList>

#include "src/application/account/AccountsService.hpp"
#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"

namespace services = budgetpilot::application::services;

namespace budgetpilot::presentation::viewmodels {
    class TransactionEditorVm : public QObject {
        Q_OBJECT

        Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
        Q_PROPERTY(bool isSaving READ isSaving NOTIFY isSavingChanged)
        Q_PROPERTY(QVariantList accounts READ accounts NOTIFY accountsChanged);
        Q_PROPERTY(QVariantList categories READ categories NOTIFY categoriesChanged);

    public:
        explicit TransactionEditorVm(
            services::TransactionService &transactionService,
            services::AccountService &account_service,
            services::CategoryService &category_service,
            QObject *parent = nullptr
        );

        [[nodiscard]]
        QVariantList accounts() const;

        [[nodiscard]]
        QVariantList categories() const;

        [[nodiscard]]
        QString errorMessage() const;

        [[nodiscard]]
        bool isSaving() const;

        Q_INVOKABLE bool saveTransaction(
            bool is_edit,
            std::uint64_t id,
            double amount,
            const QString &type,
            const std::int64_t &account_id,
            const std::int64_t &category_id,
            const QString &source,
            const QDate &date,
            const QString &note
        );

        Q_INVOKABLE void loadInitialData();

    signals:
        void errorMessageChanged();
        void isSavingChanged();
        void transactionCreated();
        void accountsChanged();
        void categoriesChanged();

    private:
        void setErrorMessage(const QString &message);
        void setIsSaving(bool isSaving);
        void loadAccounts();
        void loadCategories();

        services::TransactionService &transaction_service_;
        services::AccountService &account_service_;
        services::CategoryService &category_service_;

        QString error_message_;
        QVariantList accounts_;
        QVariantList categories_;

        bool is_saving_ = false;
    };
}
