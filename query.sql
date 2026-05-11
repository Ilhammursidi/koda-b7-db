-- login
SELECT id, email, password, pin
FROM users 
WHERE email = 'ghaluh1@mail.com' AND password = 'pass123';

-- register
INSERT INTO users (email, password) VALUES
('ilham@mail.com', 'pass123');

INSERT INTO wallet (user_id, balance) VALUES
(11, 0);

-- get user login information
SELECT fullname, email, photo_path FROM users
WHERE id = 2;

-- get/check user pin
SELECT id, email, pin FROM users 
WHERE id = 4;

-- get transaction history
SELECT  w.user_id, t.type, t.amount, t.status 
FROM transactions t
JOIN wallet w ON t.user_id = w.user_id
WHERE w.user_id = 7; 

-- get user history with option (income/expense, date range)
SELECT w.user_id, t.type, t.amount, t.status, t.created_at AS date_range,
CASE
    WHEN type IN ('TRANSFER_OUT') THEN 'expense'
    WHEN type IN ('TOPUP','TRANSFER_IN') THEN 'income'
END AS type
FROM transactions t
JOIN wallet w ON t.user_id = w.user_id
WHERE t.user_id = 1 AND t.created_at BETWEEN '2026-05-01 00:00:00' AND '2026-05-31 23:59:59'

-- get user account information (balance, income, expense)
SELECT w.user_id, u.fullname, w.balance,(
    SELECT SUM(amount)
    FROM transactions
    WHERE user_id = w.user_id 
    AND type IN ('TOPUP','TRANSFER_IN')
    AND status = 'SUCCESS'
) AS income, (
    SELECT SUM(amount)
    FROM transactions 
    WHERE user_id = w.user_id
    AND type = 'TRANSFER_OUT'
    AND status = 'SUCCESS' 
) AS expense 
FROM transactions t
JOIN wallet w ON w.id = t.user_id
JOIN users u ON u.id = w.user_id
WHERE t.created_at BETWEEN '2026-05-01 00:00:00' 
AND '2026-05-31 23:59:59' AND w.user_id = 7
GROUP BY w.user_id, u.fullname, w.balance

-- find receiver with pagination
SELECT t.wallet_id, u.fullname, u.phone_number, u.photo_path
FROM users u
JOIN transaction t ON u.id = t.wallet_id
WHERE u.id != 1 AND (u.fullname ILIKE '%g%')
LIMIT 5
OFFSET 0

-- create transaction/topup
BEGIN;
INSERT INTO topup_details
(wallet_id, order_amount, tax_amount, delivery_fee, total_amount, payment_method_id, status)
VALUES (11, 200000, 1000, 1000, 198000, 1, 'SUCCESS');
INSERT INTO transactions (user_id, receiver_wallet_id, type, payment_method_id, amount, status)
VALUES (11, 11, 'TOPUP', 1, 198000, 'SUCCESS');
UPDATE wallet SET balance = balance + 198000,
updated_at = NOW()
WHERE user_id = 11;
COMMIT;

-- get user profile (photo, fullname, phone, email)
SELECT photo_path AS photo, fullname, phone_number, email
FROM users
WHERE id = 1;

-- change pin
UPDATE users SET pin = '222222',
updated_at = NOW()
WHERE id = 11;

-- change password
UPDATE users SET password = 'ilham100',
updated_at = NOW()
WHERE id = 2;

-- change user profile
UPDATE users 
SET fullname = 'ilham mursidi',
photo_path = 'https://i.pravtar.cc/150?u=11',
phone_number = '0812 3456 8910', 
updated_at = NOW()
WHERE id = 11;

table users