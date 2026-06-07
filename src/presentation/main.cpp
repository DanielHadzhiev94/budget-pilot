#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/DbContext.hpp"
#include "../infrastructure/repositories/AccountRepository.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"
#include "src/infrastructure/repositories/CategoryRepository.hpp"
#include "src/application/account/AccountsService.hpp"
#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "viewmodels/AddTransactionDialogVm.hpp"
#include "viewmodels/FinancialSummaryVm.hpp"
#include "viewmodels/RecentTransactionVm.hpp"
#include "viewmodels/TransactionTableVm.hpp"

namespace services = budgetpilot::application::services;
namespace repository = budgetpilot::infrastructure::repositories;
namespace persistence = budgetpilot::infrastructure::persistence;
namespace viewmodels = budgetpilot::presentation::viewmodels;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Initialization of the database
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString dbFilePath = QDir(appDataPath).filePath("budgetpilot.db");
    std::string dbPath = dbFilePath.toStdString();
    persistence::DbContext dbContext{dbPath};
    dbContext.initialize();

    // Repositories
    repository::AccountRepository account_repository{*dbContext.getConnection()};
    repository::TransactionRepository transaction_repository{*dbContext.getConnection()};
    repository::CategoryRepository category_repository{*dbContext.getConnection()};

    // Services
    services::TransactionService transaction_service{
        account_repository,
        transaction_repository};

    services::AccountService account_service{
        account_repository,
        transaction_repository,
    };

    // Synchronize accounts upon loading
    account_service.synchronize_accounts();

    services::CategoryService category_service{
        category_repository,
    };

    // Starting Qt engine
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QQuickStyle::setStyle("Basic");

    // Initializing of the ViewModels
    viewmodels::FinancialSummaryVm financialSummaryViewModel{
        transaction_service,
        account_service};

    viewmodels::AddTransactionDialogVm addDialogViewModel{
        transaction_service,
        account_service,
        category_service,
    };

    viewmodels::RecentTransactionVm recentTransactionsViewModel{
        transaction_service,
        category_service};

    viewmodels::TransactionTableVm transactionTableViewModel{
        transaction_service,
        category_service};

    engine.rootContext()->setContextProperty("financialSummaryVM", &financialSummaryViewModel);
    engine.rootContext()->setContextProperty("addTransactionVM", &addDialogViewModel);
    engine.rootContext()->setContextProperty("recentTransactionsVM", &recentTransactionsViewModel);
    engine.rootContext()->setContextProperty("transactionTableVM", &transactionTableViewModel);

    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
