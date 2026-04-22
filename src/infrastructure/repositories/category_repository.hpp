#pragma once
#include <sqlite3.h>

#include "../../domain/interfaces/repository.hpp"

namespace budgetpilot {
    namespace domain::model {
        struct Category;
    }

    using namespace domain::interface;
    using namespace domain::model;

    namespace infrastructure::repositories {
        class CategoryRepository : public IRepository<Category> {
        public:
            explicit CategoryRepository(sqlite3 *db);

            void add(Category entity) override;
            void update(Category entity) override;
            void remove(std::uint64_t id) override;

            std::vector<Category> getAll() override;
            Category getOne(std::uint64_t id) override;

        private:
            sqlite3 *connection_;
        };
    }
}
