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

        src/infrastructure/persistence/DbContext.hpp
        src/infrastructure/persistence/DbContext.cpp

        src/domain/models/Transaction.hpp
        src/domain/models/Category.hpp
        src/domain/models/Account.hpp

        src/domain/contracts/IRepository.hpp

        src/infrastructure/persistence/Statement.hpp
        src/infrastructure/persistence/Statement.cpp

        src/infrastructure/repositories/TransactionRepository.hpp
        src/infrastructure/repositories/TransactionRepository.cpp

        src/infrastructure/repositories/AccountRepository.hpp
        src/infrastructure/repositories/AccountRepository.cpp

        src/infrastructure/repositories/CategoryRepository.hpp
        src/infrastructure/repositories/CategoryRepository.cpp
        src/presentation/viewmodels/FinancialSummaryVm.hpp
        src/presentation/viewmodels/FinancialSummaryVm.cpp
        src/application/transaction/TransactionService.hpp
        src/domain/utilities/Response.hpp
        src/application/transaction/TransactionService.cpp
        src/presentation/viewmodels/AddTransactionDialogVm.hpp
        src/presentation/viewmodels/AddTransactionDialogVm.cpp
        src/domain/utilities/Mapper.hpp
        src/application/account/AccountsService.hpp
        src/application/account/AccountService.cpp
        src/application/category/CategoryService.hpp
        src/application/category/CategoryService.cpp
        src/domain/utilities/TimeConverter.hpp
        src/domain/models/Enums.hpp
        src/domain/contracts/ITransactionRepository.hpp
        src/presentation/viewmodels/RecentTransactionVm.hpp
        src/presentation/viewmodels/RecentTransactionVm.cpp
        src/presentation/pages/TransactionsPage.qml
        src/presentation/viewmodels/TransactionTableVm.hpp
        src/presentation/viewmodels/TransactionTableVm.cpp
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
        src/presentation/components/SidebarItem.qml
        src/presentation/components/TransactionTable.qml
        src/presentation/components/TransactionTableHeader.qml
        src/presentation/components/TransactionActionButton.qml
        src/presentation/components/TypeBadge.qml
        src/presentation/components/Dialog.qml
        src/presentation/components/AddButton.qml
        src/presentation/sections/FinancialSummarySection.qml
        src/presentation/sections/RecentTransactionsSection.qml
        src/presentation/sections/ExpenseCategoryPreviewSection.qml
        src/presentation/sections/TransactionTableSection.qml
        src/presentation/pages/DashboardPage.qml
        src/presentation/pages/TransactionsPage.qml

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