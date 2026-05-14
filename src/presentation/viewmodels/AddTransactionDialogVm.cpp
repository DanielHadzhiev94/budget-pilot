#include "AddTransactionDialogVm.hpp"
#include "src/domain/model/Transaction.hpp"
#include "src/domain/utilities/Mapper.hpp"

namespace services = budgetpilot::application::services;
namespace models = budgetpilot::domain::models;
namespace utilities = budgetpilot::domain::utilities;

namespace budgetpilot::presentation::viewmodels {
    AddTransactionDialogVm::AddTransactionDialogVm(services::TransactionService &transactionService,
                                                   services::AccountService &account_service,
                                                   services::CategoryService &category_service,
                                                   QObject *parent)
        : transaction_service_(transactionService),
          account_service_(account_service),
          category_service_(category_service) {
    }

    QVariantList AddTransactionDialogVm::accounts() const {
        return accounts_;
    }

    QVariantList AddTransactionDialogVm::categories() const {
        return categories_;
    }

    QString AddTransactionDialogVm::errorMessage() const {
        return error_message_;
    }

    bool AddTransactionDialogVm::isSaving() const {
        return is_saving_;
    }

    void AddTransactionDialogVm::loadAccounts() {
        accounts_.clear();

        const auto accounts_response = account_service_.load_accounts();

        if (accounts_response.is_successful()) {
            for (auto &account: accounts_response.data()) {
                QVariantMap item;
                item["name"] = QString::fromStdString(account.name);
                item["id"] = static_cast<qlonglong>(account.id);
                accounts_.append(item);
            }
        }

        emit accountsChanged();
    }

    void AddTransactionDialogVm::loadCategories() {
        categories_.clear();

        const auto categories_response = category_service_.load_category();
        if (categories_response.is_successful()) {
            for (auto &category: categories_response.data()) {
                QVariantMap item;
                item["name"] = QString::fromStdString(category.name);
                item["id"] = static_cast<qlonglong>(category.id);
                categories_.append(item);
            }
        }

        emit categoriesChanged();
    }

    bool AddTransactionDialogVm::saveTransaction(
        const double amount,
        const QString &type,
        const std::int64_t &account_id,
        const std::int64_t &category_id,
        const QString &source,
        const QDate &date,
        const QString &note
    ) {
        setErrorMessage("");

        if (amount <= 0.0) {
            setErrorMessage("Amount must be greater than zero.");
            return false;
        }

        setIsSaving(true);

        models::Transaction transaction{};
        transaction.amount = static_cast<double>(amount);
        transaction.source = source.toStdString();
        transaction.note = note.toStdString();
        transaction.transaction_date = utilities::Mapper::qdate_to_timepoint(date);

        transaction.account_id = account_id;

        // Temporary until you have proper category lookup.
        transaction.category_id = 1;

        if (type == "Income") {
            transaction.type = enums::Type::Income;
        } else {
            transaction.type = enums::Type::Expense;
        }

        const auto response = transaction_service_.create_transaction(transaction);

        setIsSaving(false);

        if (!response.is_successful()) {
            setErrorMessage(QString::fromStdString(response.message()));
            return false;
        }

        emit transactionCreated();
        return true;
    }

    void AddTransactionDialogVm::loadInitialData() {
        loadAccounts();
        loadCategories();
    }

    void AddTransactionDialogVm::setErrorMessage(const QString &message) {
        if (error_message_ == message) {
            return;
        }

        error_message_ = message;
        emit errorMessageChanged();
    }

    void AddTransactionDialogVm::setIsSaving(bool isSaving) {
        if (is_saving_ == isSaving) {
            return;
        }

        is_saving_ = isSaving;
        emit isSavingChanged();
    }
}
