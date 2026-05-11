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
WHERE w.user_id = 2; 

-- get user history with option (income/expense, date range)
SELECT w.user_id, t.type, t.amount, t.status, t.created_at AS date_range
FROM transactions t
JOIN wallet w ON t.user_id = w.id
JOIN users u ON w.user_id = u.id
WHERE t.created_at BETWEEN '2026-05-01 00:00:00'
AND '2026-05-11 23:59:59' AND t.status = 'SUCCESS'
AND type IN ('TOPUP','TRANSFER_IN') OR type IN ('TRANSFER_OUT')
AND u.id = 1
ORDER BY t.created_at DESC;

-- get user account information (balance, income, expense)
SELECT w.user_id, u.fullname, w.balance,(
    SELECT SUM(amount)
    FROM transactions
    WHERE wallet_id = w.user_id 
    AND type IN ('TOPUP','TRANSFER_IN')
    AND status = 'SUCCESS'
) AS income, (
    SELECT SUM(amount)
    FROM transactions 
    WHERE wallet_id = w.user_id
    AND type = 'TRANSFER_OUT'
    AND status = 'SUCCESS' 
) AS expense 
FROM transactions t
JOIN wallet w ON w.id = t.wallet_id
JOIN users u ON u.id = w.user_id
WHERE t.created_at BETWEEN '2026-05-01 00:00:00' 
AND '2026-05-10 23:59:59' AND w.user_id = 7
GROUP BY w.user_id, u.fullname, w.balance

-- find receiver with pagination
SELECT t.wallet_id, u.fullname, u.phone_number, u.photo_path
FROM users u
JOIN transaction t ON u.id = t.wallet_id
WHERE u.id != 1 AND (u.fullname ILIKE '%g%')
LIMIT 5
OFFSET 0

-- create transaction/topup
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (3, 25000, 2);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (3, 'TOPUP', 25000, 'SUCCESS')
UPDATE wallet SET balance = balance + 25000
updated_at = NOW(), 
WHERE id = 3;

table wallet

-- get user profile (photo, fullname, phone, email)
SELECT photo_path AS photo, fullname, phone_number, email
FROM users
WHERE id = 1;

-- change pin
UPDATE users SET pin = '222222',
updated_at = NOW()
WHERE id = 1;

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