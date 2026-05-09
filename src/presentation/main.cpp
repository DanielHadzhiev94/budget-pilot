#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/DbContext.hpp"
#include "../infrastructure/repositories/AccountRepository.hpp"
#include "src/application/account/AccountsService.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"
#include "viewmodels/AddTransactionDialogVm.hpp"
#include "viewmodels/FinancialSummaryVm.hpp"

namespace account = budgetpilot::application::account;
namespace transaction = budgetpilot::application::transaction;
namespace repository = budgetpilot::infrastructure::repositories;
namespace persistence = budgetpilot::infrastructure::persistence;
namespace viewmodels = budgetpilot::presentation::viewmodels;

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);


    // Initialization of the database
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString dbFilePath = QDir(appDataPath).filePath("budgetpilot.db");
    std::string dbPath = dbFilePath.toStdString();
    const auto dbContext = std::make_unique<persistence::DbContext>(dbPath);
    dbContext->initialize();

    //Repositories
    repository::AccountRepository account_repository{dbContext->getConnection()};
    repository::TransactionRepository transaction_repository{dbContext->getConnection()};

    // Services
    transaction::TransactionService transaction_service{
        &account_repository,
        &transaction_repository
    };

    account::AccountService account_service
    {
        account_repository,
    };

    // Starting Qt engine
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QQuickStyle::setStyle("Basic");

    // Initializing of the ViewModels
    viewmodels::FinancialSummaryVm financialSummaryViewModel{
        &transaction_service
    };

    viewmodels::AddTransactionDialogVm addDialogViewModel{
        transaction_service,
        account_service,
    };

    engine.rootContext()->setContextProperty("dashboardVM", &financialSummaryViewModel);
    engine.rootContext()->setContextProperty("addtransactionVM", &addDialogViewModel);
    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
