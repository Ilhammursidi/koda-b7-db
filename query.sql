-- login
SELECT id, email, password, pin
FROM users 
WHERE email = 'ghaluh1@mail.com' AND password = 'pass123';

-- register
INSERT INTO users (email, password) VALUES
('ilham@mail.com', 'pass123');
table users;
INSERT INTO wallet (user_id, balance) VALUES
(11, 0);

-- get user login information
SELECT fullname, email, photo_path FROM users
WHERE id = 2;

-- get/check user pin
SELECT id, email, pin FROM users 
WHERE id = 4;

-- get transaction history
SELECT wallet_id, type, amount, status 
FROM transaction
WHERE id = 3;

-- get user history with option (income/expense, date range)
SELECT t.wallet_id, t.type, t.amount, t.status, t.created_at AS date
FROM transaction t
JOIN wallet w ON t.wallet_id = w.id
JOIN users u ON w.user_id = u.id
WHERE t.created_at BETWEEN '2026-05-01 00:00:00'
AND '2026-05-10 23:59:59' AND t.status = 'SUCCESS'
AND type IN ('TOPUP','TRANSFER_IN') -- income
-- AND type IN ('TRANSFER_OUT') -- expense
AND u.id = 1
ORDER BY t.created_at DESC;

-- get user account information (balance, income, expense)
SELECT w.user_id, u.fullname, w.balance,(
    SELECT SUM(amount) AS income
    FROM transaction
    WHERE wallet_id = w.user_id 
    AND status = 'SUCCESS'
    AND type IN ('TOPUP','TRANSFER_IN')
) AS income, (
    SELECT SUM(amount) AS expense
    FROM transaction 
    WHERE wallet_id = w.user_id
    AND status = 'SUCCESS' 
    AND type = 'TRANSFER_OUT'
) AS expense 
FROM transaction t
JOIN wallet w ON w.id = t.wallet_id
JOIN users u ON u.id = w.user_id
WHERE t.created_at BETWEEN '2026-05-01 00:00:00' 
AND '2026-05-10 23:59:59' AND w.user_id = 7
GROUP BY w.user_id, u.fullname, w.balance

-- find receiver with pagination
SELECT t.wallet_id, u.fullname, u.phone_number, u.photo_path
FROM users u
JOIN transaction t ON u.id = t.wallet_id
WHERE u.id != 1 -- if is login user 1
LIMIT 2
OFFSET 0

-- create transaction/topup
INSERT INTO transaction (wallet_id, type, amount, status) 
VALUES (1, 'TOPUP', 100000, 'SUCCESS');
UPDATE wallet 
SET balance = balance + 100000, 
    updated_at = NOW()
WHERE id = 1;

-- get user profile (photo, fullname, phone, email)
SELECT photo_path, fullname, phone_number, email
FROM users
WHERE id = 1;

-- change pin
UPDATE users SET pin = '222222' WHERE id = 1;
UPDATE users SET pin = '111111' WHERE id = 11;

-- change password
UPDATE users SET password = 'ilham123' WHERE id = 2;

-- change user profile
UPDATE users 
SET fullname = 'ilham mursidi',
photo_path = 'https://i.pravtar.cc/150?u=11',
phone_number = '0812 3456 8910' WHERE id = 11;