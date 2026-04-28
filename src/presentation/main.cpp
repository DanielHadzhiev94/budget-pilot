#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>

#include "../infrastructure/persistence/dbcontext.hpp"
#include "../domain/model/account.hpp"
#include "../infrastructure/repositories/account_repository.hpp"
#include "../infrastructure/repositories/category_repository.hpp"
#include "../infrastructure/repositories/transaction_repository.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    using namespace budgetpilot::infrastructure::repositories;

    // DB connection
    try {
        QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(appDataPath);

        std::string dbPath = (appDataPath + "/budgetpilot.db").toStdString();

        budgetpilot::infrastructure::persistence::DbContext dbContext(dbPath);
        dbContext.initialize();

        // Test adding a trascation};
        TransactionRepository repo{dbContext.getConnection()};
        CategoryRepository cat_repo{dbContext.getConnection()};


        // repo.add(budgetpilot::domain::model::Transaction{
        //     1,
        //     1,
        //     budgetpilot::domain::model::Type::Income,
        //     234.0,
        //     now,
        //     "Source",
        //     "This is note"
        // });

        AccountRepository acc_repo{dbContext.getConnection()};

        auto a = acc_repo.getOne(1);
        auto b = a;
    } catch (const std::exception &ex) {
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
    QQuickStyle::setStyle("Basic");
    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
