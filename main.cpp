#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QDir>

#include "../BudgetPilot/infrastructure/persistence /dbcontext.hpp"
#include "domain/model/transaction.hpp"
#include "infrastructure/repositories/transaction_repository.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // DB connection
    try {
        QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(appDataPath);

        std::string dbPath = (appDataPath + "/budgetpilot.db").toStdString();

        budgetpilot::infrastructure::persistence::DbContext dbContext(dbPath);
        dbContext.initialize();

        // Test adding a trascation
        budgetpilot::domain::model::Transaction trans = budgetpilot::domain::model::Transaction{1,"Salary", budgetpilot::domain::model::Type::INCOME, 3000.f, 1};
        budgetpilot::infrastructure::repositories::TransactionRepository repo = budgetpilot::infrastructure::repositories::TransactionRepository(dbContext.getConnection());
        repo.add(trans);

    } catch (const std::exception& ex) {
        std::cout << "Error opening database connection: " << ex.what() << "\n";
        return -1;
    }

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
