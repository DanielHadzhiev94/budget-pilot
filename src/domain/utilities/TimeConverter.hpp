#pragma once

#include <chrono>
#include <cstdint>
#include <ctime>

namespace budgetpilot::domain::utilities {
    using TimePoint = std::chrono::system_clock::time_point;

    class TimeConverter {
    public:
        TimeConverter() = delete;

        static std::int64_t convert_to_seconds(TimePoint time_point) {
            return std::chrono::duration_cast<std::chrono::seconds>(
                time_point.time_since_epoch()
            ).count();
        }

        static TimePoint from_unix(std::int64_t value) {
            return TimePoint{std::chrono::seconds{value}};
        }

        static std::int64_t next_month_to_unix_seconds(int selected_month, int selected_year) {
            ++selected_month;

            if (selected_month > 12) {
                selected_month = 1;
                ++selected_year;
            }

            return to_unix_seconds(selected_month, selected_year);
        }

        static std::int64_t to_unix_seconds(int selected_month, int selected_year) {
            std::tm date{};
            date.tm_year = selected_year - 1900;
            date.tm_mon = selected_month - 1;
            date.tm_mday = 1;
            date.tm_hour = 0;
            date.tm_min = 0;
            date.tm_sec = 0;
            date.tm_isdst = -1;

            const std::time_t timestamp = std::mktime(&date);
            return static_cast<std::int64_t>(timestamp);
        }
    };
}
