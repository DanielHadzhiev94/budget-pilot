#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/DbContext.hpp"
#include "../infrastructure/repositories/AccountRepository.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"
#include "viewmodels/AddTransactionDialogVm.hpp"
#include "viewmodels/FinancialSummaryVm.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    using namespace budgetpilot::application::transaction;
    using namespace budgetpilot::infrastructure::repositories;
    using namespace budgetpilot::infrastructure::persistence;
    using namespace budgetpilot::presentation::viewmodels;

    // Initialization of the database
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString dbFilePath = QDir(appDataPath).filePath("budgetpilot.db");
    std::string dbPath = dbFilePath.toStdString();
    const auto dbContext = std::make_unique<DbContext>(dbPath);
    dbContext->initialize();

    //Repositories
    AccountRepository account_repository{dbContext->getConnection()};
    TransactionRepository transaction_repository{dbContext->getConnection()};

    // Services
    TransactionService transaction_service{
        &account_repository,
        &transaction_repository
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
    FinancialSummaryVm financialSummaryViewModel{
        &transaction_service
    };

    AddTransactionDialogVm addDialogViewModel{
        &transaction_service
    };

    engine.rootContext()->setContextProperty("dashboardVM", &financialSummaryViewModel);
    engine.rootContext()->setContextProperty("addtransactionVM", &addDialogViewModel);
    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
