#include "FinancialSummaryVm.hpp"

FinancialSummaryVm::FinancialSummaryVm(QObject *parent) {

}

double FinancialSummaryVm::current_balance()const {
    return current_balance_;
}

void FinancialSummaryVm::add_income(){
    current_balance_ += 100;
    emit current_balance_changed();
}