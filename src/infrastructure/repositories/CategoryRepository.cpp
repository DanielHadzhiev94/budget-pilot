#include "CategoryRepository.hpp"

#include <stdexcept>

#include "../../domain/model/Category.hpp"
#include "src/infrastructure/persistence/Statement.hpp"

namespace models = budgetpilot::domain::models;

namespace budgetpilot::infrastructure::repositories {
    CategoryRepository::CategoryRepository(sqlite3 &db)
        : connection_(db) {
    }

    void CategoryRepository::add(const models::Category &entity) {
        const auto sql = R"(
        INSERT INTO categories (name)
        VALUES(?)
        )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, nullptr);

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void CategoryRepository::update(const models::Category &entity) {
        const auto sql = R"(
                             UPDATE categories
                             SET name = ?
                             WHERE  id = ?
                           )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_text(stmt.get(), 1, entity.name.c_str(), -1, nullptr);
        sqlite3_bind_int64(stmt.get(), 2, entity.id);

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    void CategoryRepository::remove(const std::uint64_t &id) {
        const auto sql = R"(DELETE FROM categories
                            WHERE id = ?
                            )";

        persistence::Statement stmt{&connection_, sql};
        sqlite3_bind_int64(stmt.get(), 1, id);

        int result = sqlite3_step(stmt.get());
        if (result != SQLITE_DONE) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }
    }

    std::vector<models::Category> CategoryRepository::getAll(int month, int year) {
        const auto *sql = R"(
                    SELECT id, name, created_at
                    FROM categories
                    )";

        const persistence::Statement stmt(&connection_, sql);
        std::vector<models::Category> categories{};

        while (sqlite3_step(stmt.get()) == SQLITE_ROW) {
            models::Category category{};

            category.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

            const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
            category.name = name ? reinterpret_cast<const char *>(name) : "";

            const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
            category.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

            categories.push_back(std::move(category));
        }

        return categories;
    }

    std::optional<models::Category> CategoryRepository::getOne(const std::uint64_t &id) {
        const char *sql = R"(
        SELECT id, name, created_at
        FROM categories
        WHERE id = ?
    )";

        persistence::Statement stmt(&connection_, sql);
        sqlite3_bind_int64(stmt.get(), 1, static_cast<sqlite3_int64>(id));

        const int result = sqlite3_step(stmt.get());

        if (result == SQLITE_DONE) {
            throw std::runtime_error("Category not found");
        }

        if (result != SQLITE_ROW) {
            throw std::runtime_error(sqlite3_errmsg(&connection_));
        }

        models::Category category{};

        category.id = static_cast<std::uint64_t>(sqlite3_column_int64(stmt.get(), 0));

        const unsigned char *name = sqlite3_column_text(stmt.get(), 1);
        category.name = name ? reinterpret_cast<const char *>(name) : "";

        const unsigned char *created_at = sqlite3_column_text(stmt.get(), 3);
        category.created_at = created_at ? reinterpret_cast<const char *>(created_at) : "";

        return category;
    }
}
