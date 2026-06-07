#pragma once

#include <ctime>

namespace budgetpilot::domain::utilities
{
    struct MonthYear
    {
        int month;
        int year;

        static MonthYear current()
        {
            std::time_t now = std::time(nullptr);
            std::tm *localTime = std::localtime(&now);

            return {
                localTime->tm_mon + 1,
                localTime->tm_year + 1900};
        }

        MonthYear subtract_months(int months_to_subtract) const
        {
            int result_month = month - months_to_subtract;
            int result_year = year;

            while (result_month <= 0)
            {
                result_month += 12;
                result_year -= 1;
            }

            return {
                result_month,
                result_year};
        }
    };
}