#pragma once
#include <cstdint>
#include<chrono>

using TimePoint = std::chrono::system_clock::time_point;

namespace budgetpilot::domain::utilities {
    class TimeConverter {
    public:
        TimeConverter() = delete;

        static std::int64_t convert_to_seconds(TimePoint time_point) {
            return std::chrono::duration_cast<std::chrono::seconds>(
                time_point.time_since_epoch()
            ).count();
        }

        static std::chrono::system_clock::time_point from_unix(std::int64_t value) {
            return std::chrono::system_clock::time_point{
                std::chrono::seconds{value}
            };
        }

        static std::int64_t next_month_to_unix_seconds(int selectedMonth, int selectedYear) {
            auto next_month = selectedMonth + 1;
            if (next_month > 12) {
                next_month = 1;
            }

            return to_unix_seconds(next_month, selectedYear);
        }


        static std::int64_t to_unix_seconds(int selectedMonth, int selectedYear) {
            std::tm date{};

            date.tm_year = selectedYear - 1900; // years since 1900
            date.tm_mon = selectedMonth - 1; // months are 0-based: January = 0
            date.tm_mday = 1; // first day of month
            date.tm_hour = 0;
            date.tm_min = 0;
            date.tm_sec = 0;

            std::time_t timestamp = std::mktime(&date);

            return static_cast<std::int64_t>(timestamp);
        }
    };
}
