INSERT INTO payment_methods (payment_name) VALUES
('Bank Rakyat Indonesia'),
('Dana'),
('Bank Central Asia'),
('Gopay'),
('Ovo');

INSERT INTO users (email, password, pin, fullname, photo_path, phone_number) VALUES
('ghaluh1@mail.com', 'pass123', '123456', 'Ghaluh 1', 'https://i.pravtar.cc/150?u=1', '082134348877'),
('jhoncena@mail.com', 'pass123', '111111', 'Jhon Cena', 'https://i.pravtar.cc/150?u=2', '(239) 555-0108'),
('younglex@mail.com', 'pass123', '222222', 'Young Lex', 'https://i.pravtar.cc/150?u=3', '(239) 453-7432'),
('brunomars@mail.com', 'pass123', '333333', 'Bruno Mars', 'https://i.pravtar.cc/150?u=4', '(239) 009-9231'),
('brunopluto@mail.com', 'pass123', '444444', 'Bruno Pluto', 'https://i.pravtar.cc/150?u=5', '(239) 555-2000'),
('brunobogor@mail.com', 'pass123', '555555', 'Bruno Bogor', 'https://i.pravtar.cc/150?u=6', '081524249988'),
('brunogputri@mail.com', 'pass123', '666666', 'Bruno G Putri', 'https://i.pravtar.cc/150?u=7', '(239) 555-0108'),
('brunowanher@mail.com', 'pass123', '777777', 'Bruno wanher', 'https://i.pravtar.cc/150?u=8', '(239) 555-2000'),
('brunodgarut@mail.com', 'pass123', '888888', 'Bruno D Garut', 'https://i.pravtar.cc/150?u=9', '081524249988'),
('brunogmau@mail.com', 'pass123', '999999', 'Bruno G Mau', 'https://i.pravtar.cc/150?u=10', '(239) 555-0108');

table users;

INSERT INTO wallet (user_id, balance) VALUES
(1, 1000000), 
(2, 500000), 
(3, 750000), 
(4, 2000000),
(5, 100000),  
(6, 1500000), 
(7, 300000),  
(8, 0),       
(9, 250000),  
(10, 5000000);

BEGIN;

-- 1. Tambahkan riwayat ke tabel topup
INSERT INTO topup (wallet_id, amount, payment_method_id) 
VALUES (1, 100000, 1); 

-- 2. Tambahkan riwayat ke tabel transaction (sebagai log umum)
INSERT INTO transaction (wallet_id, type, amount, status) 
VALUES (1, 'TOPUP', 100000, 'SUCCESS');

-- 3. Update saldo di tabel wallet (ditambah dari saldo lama)
UPDATE wallet 
SET balance = balance + 100000, 
    updated_at = NOW()
WHERE id = 1;

COMMIT;

table topup;

BEGIN;

-- Topup 2: User 2 topup 100rb via BCA
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (2, 100000, 3);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (2, 'TOPUP', 100000, 'SUCCESS');
UPDATE wallet SET balance = balance + 100000 WHERE id = 2;

-- Topup 3: User 3 topup 25rb via Dana
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (3, 25000, 2);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (3, 'TOPUP', 25000, 'SUCCESS');
UPDATE wallet SET balance = balance + 25000 WHERE id = 3;

-- Topup 4: User 4 topup 200rb via Gopay
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (4, 200000, 4);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (4, 'TOPUP', 200000, 'SUCCESS');
UPDATE wallet SET balance = balance + 200000 WHERE id = 4;

-- Topup 5: User 5 topup 150rb via Ovo
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (5, 150000, 5);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (5, 'TOPUP', 150000, 'SUCCESS');
UPDATE wallet SET balance = balance + 150000 WHERE id = 5;

COMMIT;

table transfer;
table transaction;
BEGIN;

-- Transfer 1: User 1 kirim ke User 2 (20rb)
INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES (1, 2, 20000);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (1, 'TRANSFER_OUT', 20000, 'SUCCESS');
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (2, 'TRANSFER_IN', 20000, 'SUCCESS');
UPDATE wallet SET balance = balance - 20000 WHERE id = 1;
UPDATE wallet SET balance = balance + 20000 WHERE id = 2;

-- Transfer 2: User 4 kirim ke User 5 (50rb)
INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES (4, 5, 50000);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (4, 'TRANSFER_OUT', 50000, 'SUCCESS');
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (5, 'TRANSFER_IN', 50000, 'SUCCESS');
UPDATE wallet SET balance = balance - 50000 WHERE id = 4;
UPDATE wallet SET balance = balance + 50000 WHERE id = 5;

-- Transfer 3: User 6 kirim ke User 7 (100rb)
INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES (6, 7, 100000);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (6, 'TRANSFER_OUT', 100000, 'SUCCESS');
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (7, 'TRANSFER_IN', 100000, 'SUCCESS');
UPDATE wallet SET balance = balance - 100000 WHERE id = 6;
UPDATE wallet SET balance = balance + 100000 WHERE id = 7;

-- Transfer 4: User 10 kirim ke User 1 (250rb)
INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES (10, 1, 250000);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (10, 'TRANSFER_OUT', 250000, 'SUCCESS');
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (1, 'TRANSFER_IN', 250000, 'SUCCESS');
UPDATE wallet SET balance = balance - 250000 WHERE id = 10;
UPDATE wallet SET balance = balance + 250000 WHERE id = 1;

-- Transfer 5: User 9 kirim ke User 3 (30rb)
INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES (9, 3, 30000);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (9, 'TRANSFER_OUT', 30000, 'SUCCESS');
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (3, 'TRANSFER_IN', 30000, 'SUCCESS');
UPDATE wallet SET balance = balance - 30000 WHERE id = 9;
UPDATE wallet SET balance = balance + 30000 WHERE id = 3;

COMMIT;

table wallet;
table transaction;

INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES

INSERT INTO transfer (sender_wallet_id, receiver_wallet_id, amount) VALUES

INSERT into transaction (wallet_id, type, amount, status) VALUES


table wallet;
table users;
table topup;


-- 1. Hapus aturan unik di tabel topup (jika ada)
ALTER TABLE topup DROP CONSTRAINT IF EXISTS topup_wallet_id_key;

-- 2. Hapus aturan unik di tabel transaction (jika ada)
ALTER TABLE transaction DROP CONSTRAINT IF EXISTS transaction_wallet_id_key;

table payment_methods;

ROLLBACK;
TRUNCATE TABLE users, wallet, topup, transaction, transfer CASCADE;

TRUNCATE TABLE users CASCADE;
ALTER SEQUENCE users_id_seq RESTART WITH 1;

TRUNCATE TABLE wallet CASCADE;
ALTER SEQUENCE wallet_id_seq RESTART WITH 1;

TRUNCATE TABLE topup CASCADE;
ALTER SEQUENCE topup_id_seq RESTART WITH 1;

TRUNCATE TABLE transaction CASCADE;
ALTER SEQUENCE transaction_id_seq RESTART WITH 1;

TRUNCATE TABLE transfer CASCADE;
ALTER SEQUENCE transfer_id_seq RESTART WITH 1;

BEGIN;

-- Topup Pending: User 6 mencoba topup 1.000.000 via BRI (Masih menunggu pembayaran)
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (6, 1000000, 1);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (6, 'TOPUP', 1000000, 'PENDING');

-- Topup Failed: User 7 mencoba topup 50.000 via Dana (Pembayaran kadaluarsa/batal)
INSERT INTO topup (wallet_id, amount, payment_method_id) VALUES (7, 50000, 2);
INSERT INTO transaction (wallet_id, type, amount, status) VALUES (7, 'TOPUP', 50000, 'FAILED');

COMMIT;