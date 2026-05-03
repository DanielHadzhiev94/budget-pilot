# Goal

- Да покаже информация включваща разходите, баланса , приходите и рейта на спестявания за избраният месец. Този секция, ще бъде част от **Dashboard** екрана.

## Components / Classes

### FinancialOverview.qml

**Отговорности**:

- При инициализацията зарежда информацията за посочените долу стойности от `TransactionService`
- Взима новата стойност на `CurrentBalance` при добавяне на транзакция.
- Взима новата стойност на `Expenses` при добавяне на транзакция.
- Взима новата стойност на `Incomes` при добавяне на транзакция.
- Изчисляваме на `Saving rates` при добавяне на транзакция.

**Функции / Класове**:

- **public:**
  - `void LoadData(Date date)`
  - `void AddTransaction(Transaction& transaction)`
  - `void GetCurrentBalance()`
  - `void GetExpenses()`
  - `void GetIncomes()`
  - `void GetSavingRates()`

### TransactionService.hpp

- **public:**
  - `Response<FinanceDto>LoadData(Date date)`
  - `Response<double> GetExpenses(Date date)`
  - `Response<double> GetIncome(Date date)`
  - `Response<double> GetCurrentBalance(Date date)`
  - `Response<double> GetSavingRates(Date date)`
  - `Response<void> AddTransaction(const Transaction&)`

- **private:**
  - `void UpdateBalance(double amount, int account_id)`

### TransactionRepository.hpp

- `Response<vector<Transaction>> GetIncomes(Date date)`
- `Response<vector<Transaction>> GetExpenses(Date date)`

### AccountRepository.hpp

- `Response<BalanceDto> GetBalance()`
