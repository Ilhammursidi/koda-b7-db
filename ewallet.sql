CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    pin VARCHAR(6),
    fullname VARCHAR(255),
    photo_path VARCHAR(255),
    phone_number VARCHAR(255) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
)

CREATE TABLE wallet (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
)

CREATE TYPE transaction_status AS ENUM ('PENDING','SUCCESS','FAILED');

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    wallet_id INT NOT NULL,
    type VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
    status transaction_status NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (wallet_id) REFERENCES wallet(id)
)

CREATE TABLE transfer (
    id SERIAL PRIMARY KEY,
    sender_wallet_id INT NOT NULL,
    receiver_wallet_id INT NOT NULL,
    amount INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (sender_wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (receiver_wallet_id) REFERENCES wallet(id)
)

CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    payment_name VARCHAR(255) NOT NULL
)

CREATE TABLE topup (
    id SERIAL PRIMARY KEY,
    wallet_id INT NOT NULL,
    amount INT NOT NULL,
    payment_method_id INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (wallet_id) REFERENCES wallet(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
)