#include "DashboardViewModel.hpp"

DashboardViewModel::DashboardViewModel(QObject *parent) {

}

double DashboardViewModel::current_balance()const {
    return current_balance_;
}

void DashboardViewModel::add_income(){
    current_balance_ += 100;
    emit current_balance_changed();
}