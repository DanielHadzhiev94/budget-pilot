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

    public:
        explicit AddTransactionDialogVm(
            application::transaction::TransactionService *transactionService,
            QObject *parent = nullptr
        );

        [[nodiscard]] QString errorMessage() const;
        [[nodiscard]] bool isSaving() const;

        Q_INVOKABLE bool saveTransaction(
            double amount,
            const QString &type,
            const QString &category,
            const QString &source,
            const QDate &date,
            const QString &note
        );

    signals:
        void errorMessageChanged();
        void isSavingChanged();
        void transactionCreated();

    private:
        void setErrorMessage(const QString &message);
        void setIsSaving(bool isSaving);

        application::transaction::TransactionService *transaction_service_;

        QString error_message_;
        bool is_saving_ = false;
    };
}
