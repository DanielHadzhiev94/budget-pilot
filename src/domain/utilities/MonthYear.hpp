#pragma once

#include <ctime>
#include <stdexcept>

namespace budgetpilot::domain::utilities
{
    struct MonthYear
    {
        int month{1};
        int year{1970};

        static MonthYear current()
        {
            const std::time_t now = std::time(nullptr);
            const std::tm *local_time = std::localtime(&now);

            if (local_time == nullptr)
            {
                throw std::runtime_error("Failed to read local time.");
            }

            return {
                local_time->tm_mon + 1,
                local_time->tm_year + 1900};
        }

        [[nodiscard]]
        MonthYear subtract_months(int months_to_subtract) const
        {
            int result_month = month - months_to_subtract;
            int result_year = year;

            while (result_month <= 0)
            {
                result_month += 12;
                --result_year;
            }

            return {result_month, result_year};
        }
    };
}
