#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/dbcontext.hpp"
#include "../infrastructure/repositories/account_repository.hpp"
#include "viewmodels/DashboardViewModel.hpp"

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


    DashboardViewModel viewModel;
    engine.rootContext()->setContextProperty("dashboardVM", &viewModel);

    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
