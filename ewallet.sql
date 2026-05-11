CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    pin VARCHAR(6),
    fullname VARCHAR(255),
    photo_path VARCHAR(255),
    phone_number VARCHAR(255) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);

CREATE TABLE wallet (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
)

CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    payment_name VARCHAR(255) NOT NULL
)

CREATE TYPE transaction_status AS ENUM ('PENDING','SUCCESS','FAILED');

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    sender_wallet_id INT,
    receiver_wallet_id INT,
    payment_method_id INT,
    type VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
    status transaction_status DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    FOREIGN KEY (sender_wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (receiver_wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
)

CREATE TABLE transfer_details (
    id SERIAL PRIMARY KEY,
    transaction_id INT UNIQUE NOT NULL,
    sender_wallet_id INT NOT NULL,
    receiver_wallet_id INT NOT NULL,
    amount INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (sender_wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (receiver_wallet_id) REFERENCES wallet(id)
)


CREATE TABLE topup_details (
    id SERIAL PRIMARY KEY,
    transaction_id INT UNIQUE NOT NULL,
    wallet_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    order_amount INT NOT NULL,
    tax_amount INT NOT NULL,
    delivery_fee INT NOT NULL,
    total_amount INT NOT NULL,
    status transaction_status NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
)

-- -- ROLLBACK

-- BEGIN;
-- TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;
-- DROP TABLE transactions CASCADE;
-- TRUNCATE TABLE users RESTART IDENTITY CASCADE;
-- DROP TABLE users CASCADE;
-- TRUNCATE TABLE topup_details RESTART IDENTITY CASCADE;
-- DROP TABLE topup_details CASCADE;
-- TRUNCATE TABLE transfer_details RESTART IDENTITY CASCADE;
-- DROP TABLE transfer_details CASCADE;
-- TRUNCATE TABLE wallet RESTART IDENTITY CASCADE;
-- DROP TABLE wallet CASCADE;
-- TRUNCATE TABLE payment_methods RESTART IDENTITY CASCADE;
-- DROP TABLE payment_methods CASCADE;
-- COMMIT;