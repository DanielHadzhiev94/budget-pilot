cmake_minimum_required(VERSION 3.16)

project(BudgetPilot VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

find_package(Qt6 REQUIRED COMPONENTS Quick Svg QuickControls2)
qt_standard_project_setup(REQUIRES 6.10)

add_subdirectory(src)
