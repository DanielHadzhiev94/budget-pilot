cmake_minimum_required(VERSION 3.16)

project(BudgetPilot VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt
find_package(Qt6 REQUIRED COMPONENTS Quick Svg QuickControls2)

qt_standard_project_setup(REQUIRES 6.10)

# Executable
qt_add_executable(appBudgetPilot
    src/presentation/main.cpp

        src/infrastructure/persistence/dbcontext.hpp
        src/infrastructure/persistence/dbcontext.cpp

        src/domain/model/transaction.hpp
        src/domain/model/category.hpp
        src/domain/model/account.hpp

        src/domain/interfaces/IRepository.hpp

        src/infrastructure/persistence/statement.hpp
        src/infrastructure/persistence/statement.cpp

        src/infrastructure/repositories/TransactionRepository.hpp
        src/infrastructure/repositories/TransactionRepository.cpp

        src/infrastructure/repositories/AccountRepository.hpp
        src/infrastructure/repositories/AccountRepository.cpp

        src/infrastructure/repositories/CategoryRepository.hpp
        src/infrastructure/repositories/CategoryRepository.cpp
    src/presentation/viewmodels/DashboardViewModel.hpp
    src/presentation/viewmodels/DashboardViewModel.cpp
        src/application/transaction/transaction_service.hpp
)

# QML Singleton
set_source_files_properties(
    src/presentation/themes/AppTheme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

# QML Module
qt_add_qml_module(appBudgetPilot
    URI BudgetPilot
    VERSION 1.0

    QML_FILES
        src/presentation/Main.qml
        src/presentation/themes/AppTheme.qml

        src/presentation/components/Sidebar.qml

        src/presentation/components/Header.qml
        src/presentation/components/CustomButton.qml
        src/presentation/components/DatePicker.qml
        src/presentation/components/BudgetCard.qml
        src/presentation/components/AddTransactionDialog.qml
        src/presentation/pages/DashboardPage.qml

    RESOURCES
        src/presentation/images/rico_robot.png
        src/presentation/images/balance.png
        src/presentation/images/income.png
        src/presentation/images/expense.png
        src/presentation/images/rate.png
        )

# Qt Creator
set(QML_IMPORT_PATH
    ${CMAKE_BINARY_DIR}
    CACHE STRING "Qt Creator QML import path"
    FORCE
)

# SQLite
add_library(sqlite3
    src/third_party/sqlite/sqlite3.c
)

target_include_directories(sqlite3 PUBLIC
    src/third_party/sqlite
)

# Linking
target_link_libraries(appBudgetPilot
    PRIVATE
        Qt6::Quick
        Qt6::Svg
        Qt6::QuickControls2
        sqlite3
)

# Platform settings
set_target_properties(appBudgetPilot PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Install
install(TARGETS appBudgetPilot
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)