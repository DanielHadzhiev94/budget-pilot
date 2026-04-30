#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QDir>
#include <qqmlcontext.h>

#include "../infrastructure/persistence/DbContext.hpp"
#include "../infrastructure/repositories/AccountRepository.hpp"
#include "viewmodels/DashboardViewModel.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    using namespace budgetpilot::infrastructure::repositories;
    using namespace budgetpilot::infrastructure::persistence;

    // Initialization of the database
    try {
        QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QString dbFilePath = QDir(appDataPath).filePath("budgetpilot.db");
        std::string dbPath = dbFilePath.toStdString();
        const auto dbContext = std::make_unique<DbContext>(dbPath);
        dbContext->initialize();
    } catch (const std::exception &ex) {
        std::cout << "Error opening database connection: " << ex.what() << "\n";
        return -1;
    }

    // Services initialization


    // Starting Qt engine
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QQuickStyle::setStyle("Basic");

    // Initializing of the viewmodels
    DashboardViewModel viewModel;
    engine.rootContext()->setContextProperty("dashboardVM", &viewModel);


    engine.loadFromModule("BudgetPilot", "Main");

    return QCoreApplication::exec();
}
