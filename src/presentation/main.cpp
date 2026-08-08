#include <iostream>
#include <cstdlib>
#include <exception>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <QDebug>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/DbContext.hpp"
#include "../infrastructure/repositories/AccountRepository.hpp"
#include "src/infrastructure/repositories/TransactionRepository.hpp"
#include "src/infrastructure/repositories/CategoryRepository.hpp"
#include "src/application/account/AccountsService.hpp"
#include "src/application/category/CategoryService.hpp"
#include "src/application/transaction/TransactionService.hpp"
#include "viewmodels/TransactionEditorVm.hpp"
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
    QGuiApplication::setWindowIcon(QIcon(QStringLiteral(":/qt/qml/BudgetPilot/images/rico_robot.png")));

    // Initialization of the database
    const QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (appDataPath.isEmpty() || !QDir().mkpath(appDataPath)) {
        qCritical() << "Could not create the application data directory:" << appDataPath;
        return EXIT_FAILURE;
    }

    QString dbFilePath = QDir(appDataPath).filePath("budgetpilot.db");
    std::string dbPath = dbFilePath.toStdString();
    persistence::DbContext dbContext{dbPath};

    try {
        dbContext.initialize();
    } catch (const std::exception &error) {
        qCritical() << "Could not initialize the database at" << dbFilePath << ":" << error.what();
        return EXIT_FAILURE;
    }

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
    const auto &msg = account_service.synchronize_accounts().message();
    std::cout << msg << "\n";

    services::CategoryService category_service{
        category_repository,
        transaction_repository,
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

    viewmodels::TransactionEditorVm addDialogViewModel{
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
