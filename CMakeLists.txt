cmake_minimum_required(VERSION 3.16)

project(BudgetPilot VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appBudgetPilot
        main.cpp
        "infrastructure/persistence /dbcontext.hpp"
        "infrastructure/persistence /dbcontext.cpp"
        domain/model/transaction.hpp
        domain/model/category.hpp
        "infrastructure/repositories/transaction_repository.hpp"
        infrastructure/repositories/transaction_repository.cpp
        "infrastructure/persistence /statement.hpp"
        "infrastructure/persistence /statement.cpp"
        domain/model/account.hpp
        infrastructure/repositories/account_repository.hpp
        infrastructure/repositories/account_repository.cpp
)

qt_add_qml_module(appBudgetPilot
        URI BudgetPilot
        QML_FILES
        Main.qml
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