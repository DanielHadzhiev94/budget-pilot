#pragma once
#include <optional>
#include <stdexcept>
#include <string>

namespace budgetpilot::domain::utilities {
    template<typename T>
    class Response {
    public:
        static Response Success(T data, std::string message = "") {
            return Response(data, message, true);
        }

        static Response Failed(std::string message) {
            return Response(std::nullopt, message, false);
        };

        [[nodiscard]] bool is_successful() const { return is_successful_; }

        std::string message() const { return message_; } // NOLINT(*-const-return-type, *-use-nodiscard)

        const T &data() const {
            if (!data_.has_value()) {
                throw std::runtime_error("Data has now value");
            }

            return data_.value();
        }

    private:
        std::optional<T> data_;
        std::string message_;
        bool is_successful_;

        Response(std::optional<T> data, std::string message, const bool is_successful)
            : data_(std::move(data)), message_(std::move(message)), is_successful_(is_successful) {
        };
    };

    template<>
    class Response<void> {
    public:
        static Response<void> Success(std::string message = "") {
            return Response<void>(std::move(message), true);
        }

        static Response<void> Failed(std::string message) {
            return Response<void>(std::move(message), false);
        }

        [[nodiscard]] bool is_successful() const {
            return is_successful_;
        }

        [[nodiscard]] const std::string &message() const {
            return message_;
        }

    private:
        std::string message_;
        bool is_successful_;

        Response(std::string message, bool is_successful)
            : message_(std::move(message)),
              is_successful_(is_successful) {
        }
    };
}
