#pragma once

#include <QDebug>
#include <QObject>
#include <QString>

#include "src/application/transaction/TransactionService.hpp"

namespace budgetpilot::presentation::viewmodels {
    class AddTransactionDialogVm : public QObject {
        Q_OBJECT

        Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
        Q_PROPERTY(bool isSaving READ isSaving NOTIFY isSavingChanged)
        Q_PROPERTY(QVariantList accounts READ accounts NOTIFY accountsChanged);

    public:
        explicit AddTransactionDialogVm(
            application::transaction::TransactionService *transactionService,
            application::account
            QObject *parent = nullptr
        );

        [[nodiscard]] QString errorMessage() const;
        [[nodiscard]] bool isSaving() const;

        Q_INVOKABLE bool saveTransaction(
            double amount,
            const QString &type,
            const std::int64_t &account_id,
            const std::int64_t &category_id,
            const QString &source,
            const QDate &date,
            const QString &note
        );

    signals:
        void errorMessageChanged();
        void isSavingChanged();
        void transactionCreated();
        void accountsChanged();

    private:
        void setErrorMessage(const QString &message);
        void setIsSaving(bool isSaving);
        void loadAccounts();

        application::transaction::TransactionService *transaction_service_;

        QString error_message_;
        QVariantList accounts_;
        bool is_saving_ = false;
    };
}
