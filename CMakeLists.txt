cmake_minimum_required(VERSION 3.16)

project(BudgetPilot VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appBudgetPilot
        main.cpp
        "src/infrastructure/persistence/dbcontext.hpp"
        "src/infrastructure/persistence/dbcontext.cpp"
        src/domain/model/transaction.hpp
        src/domain/model/category.hpp
        "src/infrastructure/repositories/transaction_repository.hpp"
        src/infrastructure/repositories/transaction_repository.cpp
        "src/infrastructure/persistence/statement.hpp"
        "src/infrastructure/persistence/statement.cpp"
        src/domain/model/account.hpp
        src/infrastructure/repositories/account_repository.hpp
        src/infrastructure/repositories/account_repository.cpp
        src/domain/interfaces/repository.hpp
        src/infrastructure/repositories/category_repository.hpp
        src/infrastructure/repositories/category_repository.cpp

)

set_source_files_properties(src/presentation/themes/AppTheme.qml
        PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appBudgetPilot
        URI BudgetPilot
        QML_FILES
            src/presentation/Main.qml
            src/presentation/themes/AppTheme.qml
            src/presentation/components/Sidebar.qml
            src/presentation/components/SidebarItem.qml
)

set_target_properties(appBudgetPilot PROPERTIES
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(appBudgetPilot
        PRIVATE Qt6::Quick
        sqlite3
)

install(TARGETS appBudgetPilot
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)