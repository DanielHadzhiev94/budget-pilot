#include "CategoryRepository.hpp"

#include <stdexcept>

#include "../../domain/models/Category.hpp"
#include "../../domain/models/Enums.hpp"
#include "../../infrastructure/persistence/Statement.hpp"

namespace models = budgetpilot::domain::models;

namespace budgetpilot::infrastructure::repositories {
    CategoryRepository::CategoryRepository(sqlite3 &db)
        : connection_(db) {
    }

    void CategoryRepository::add(const models::Category &entity) {
        const auto *sql = R"(
            INSERT INTO categories (name, type)
            VALUES (?, ?)
        )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(entity.type));

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void CategoryRepository::update(const models::Category &entity) {
        const auto *sql = R"(
            UPDATE categories
            SET name = ?, type = ?
            WHERE id = ?
        )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt.get(), 2, static_cast<int>(entity.type));
        sqlite3_bind_int64(stmt.get(), 3, static_cast<sqlite3_int64>(entity.id));

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void CategoryRepository::remove(const std::uint64_t &id) {
        const auto *sql = R"(
            DELETE FROM categories
            WHERE id = ?
        )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    std::vector<models::Category> CategoryRepository::get_all() {
        const auto *sql = R"(
            SELECT id, name, type, created_at
            FROM categories
            ORDER BY type, name
        )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<models::Category> categories{};
        int result{};

        while ((result = sqlite3_step(stmt.get())) == SQLITE_ROW) {
            models::Category category{};
            category.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

            const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
            category.name = name ? reinterpret_cast<const char *>(name) : "";
            category.type = static_cast<models::enums::Type>(sqlite3_column_int(stmt.get(), 2));

            const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
            category.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

            categories.push_back(std::move(category));
        }

        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }

        return categories;
    }

    std::optional<models::Category> CategoryRepository::get_one(const std::uint64_t &id) {
        const auto *sql = R"(
            SELECT id, name, type, created_at
            FROM categories
            WHERE id = ?
        )";

        persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_DONE) {
            return std::nullopt;
        }

        if (result != SQLITE_ROW) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }

        models::Category category{};
        category.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

        const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
        category.name = name ? reinterpret_cast<const char *>(name) : "";
        category.type = static_cast<models::enums::Type>(sqlite3_column_int(stmt.get(), 2));

        const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
        category.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

        return category;
    }
}
