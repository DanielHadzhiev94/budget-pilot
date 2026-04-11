#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QDir>

#include "../BudgetPilot/infrastructure/persistence /dbcontext.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // DB connection
    try {
        QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(appDataPath);

        std::string dbPath = (appDataPath + "/budgetpilot.db").toStdString();

        budgetpilot::infrastructure::persistence::DbContext dbContext(dbPath);
        dbContext.initialize();
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
