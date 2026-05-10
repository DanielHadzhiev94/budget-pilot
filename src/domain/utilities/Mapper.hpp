#pragma once

#include <chrono>
#include <qdatetime.h>

namespace budgetpilot::domain::utilities {
    class Mapper {
        using TimePoint = std::chrono::system_clock::time_point;

    public:
        static TimePoint qdate_to_timepoint(QDate qdate, QTime qtime) {
            return qdate_to_timepoint_(qdate, qtime);
        }

        static TimePoint qdate_to_timepoint(QDate qdate) {
            return qdate_to_timepoint_(qdate, QTime(0, 0, 0));
        }

    private:
        static TimePoint qdate_to_timepoint_(QDate qdate, QTime qtime) {
            QDateTime qDatetime(qdate, qtime);
            qint64 seconds = qDatetime.toSecsSinceEpoch();

            return std::chrono::system_clock::from_time_t(seconds);
        }
    };
}
