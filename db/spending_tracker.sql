DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL8 PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  birth_date DATE NOT NULL,
  budget INT4,
  spent INT4,
  goal VARCHAR(255) NOT NULL,
  savings INT4
);

CREATE TABLE merchants (
  id SERIAL8 PRIMARY KEY,
  logo VARCHAR(255),
  name VARCHAR(255) UNIQUE
);

CREATE TABLE categories (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255) UNIQUE
);

CREATE TABLE transactions (
  id SERIAL8 PRIMARY KEY,
  transaction_date DATE NOT NULL,
  value INT4,
  user_id INT8 REFERENCES users(id) ON DELETE CASCADE,
  merchant_id INT8 REFERENCES merchants(id) ON DELETE CASCADE,
  category_id INT8 REFERENCES categories(id) ON DELETE CASCADE,
  description TEXT
);
