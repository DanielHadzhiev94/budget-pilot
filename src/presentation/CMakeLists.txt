set(BUDGETPILOT_PRESENTATION_SOURCES
    main.cpp
    viewmodels/FinancialSummaryVm.hpp
    viewmodels/FinancialSummaryVm.cpp
    viewmodels/RecentTransactionVm.hpp
    viewmodels/RecentTransactionVm.cpp
    viewmodels/TransactionEditorVm.hpp
    viewmodels/TransactionEditorVm.cpp
    viewmodels/TransactionTableVm.hpp
    viewmodels/TransactionTableVm.cpp
)

qt_add_executable(appBudgetPilot
    ${BUDGETPILOT_PRESENTATION_SOURCES}
    ${BUDGETPILOT_DOMAIN_SOURCES}
    ${BUDGETPILOT_APPLICATION_SOURCES}
    ${BUDGETPILOT_INFRASTRUCTURE_SOURCES}
)

if(WIN32)
    target_sources(appBudgetPilot PRIVATE app_icon.rc)
endif()

if(APPLE)
    set(BUDGETPILOT_MACOS_ICON "${CMAKE_CURRENT_SOURCE_DIR}/images/BudgetPilot.icns")
    set_source_files_properties(${BUDGETPILOT_MACOS_ICON} PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources"
    )
    target_sources(appBudgetPilot PRIVATE ${BUDGETPILOT_MACOS_ICON})
endif()

set_source_files_properties(themes/AppTheme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appBudgetPilot
    URI BudgetPilot
    VERSION 1.0

    QML_FILES
    Main.qml
    themes/AppTheme.qml
    shared/cards/BudgetCard.qml
    shared/controls/AddButton.qml
    shared/controls/AppButton.qml
    shared/dialogs/ConfirmationDialog.qml
    shared/inputs/AppTextField.qml
    shared/inputs/MonthPicker.qml
    shared/layout/Header.qml
    shared/navigation/Sidebar.qml
    shared/navigation/SidebarItem.qml
    features/dashboard/ExpenseCategoryPreviewSection.qml
    features/dashboard/FinancialSummarySection.qml
    features/dashboard/RecentTransactionsSection.qml
    features/transactions/TransactionTableSection.qml
    features/transactions/editor/EntityCreationDialog.qml
    features/transactions/editor/EntitySelector.qml
    features/transactions/editor/TransactionDialog.qml
    features/transactions/editor/TransactionForm.qml
    features/transactions/table/TransactionActionButton.qml
    features/transactions/table/TransactionTable.qml
    features/transactions/table/TransactionTableHeader.qml
    features/transactions/table/TypeBadge.qml
    pages/DashboardPage.qml
    pages/TransactionsPage.qml
    pages/ExpenseCategoriesPage.qml

    RESOURCES
    images/rico_robot.png
    images/balance.png
    images/income.png
    images/expense.png
    images/rate.png
)

target_include_directories(appBudgetPilot PRIVATE ${PROJECT_SOURCE_DIR})

target_link_libraries(appBudgetPilot
    PRIVATE
    Qt6::Quick
    Qt6::Svg
    Qt6::QuickControls2
    sqlite3
)

set_target_properties(appBudgetPilot PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE_ICON_FILE BudgetPilot.icns
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR} CACHE STRING "Qt Creator QML import path" FORCE)

install(TARGETS appBudgetPilot
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
