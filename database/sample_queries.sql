USE lab_reservation_early;

SET NAMES utf8mb4;

-- ============================================================
-- 1. ALT SORGU İÇEREN SORGU
-- Amaç:
-- En az 2 aktif rezervasyonu olan laboratuvarları listelemek.
-- Bu sorguda iç SELECT önce aktif rezervasyon sayısı 2 veya daha fazla
-- olan lab_id değerlerini bulur. Dış SELECT ise bu laboratuvarların adını getirir.
-- ============================================================

SELECT
    lab_name
FROM laboratories
WHERE lab_id IN (
    SELECT
        lab_id
    FROM reservations
    WHERE status = 'active'
    GROUP BY lab_id
    HAVING COUNT(*) >= 2
);

-- Beklenen sonuç:
-- Bilgisayar Mühendisliği Laboratuvarı


-- ============================================================
-- 2. JOIN İÇEREN SORGU
-- Amaç:
-- Rezervasyonları kullanıcı, laboratuvar ve masa/istasyon bilgileriyle birlikte göstermek.
-- Bu sorgu reservations, users, laboratories ve workstations tablolarını birleştirir.
-- ============================================================

SELECT
    r.reservation_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_full_name,
    u.email,
    l.lab_name,
    w.station_code,
    w.station_name,
    r.start_time,
    r.end_time,
    r.purpose,
    r.status
FROM reservations r
JOIN users u
    ON r.user_id = u.user_id
JOIN laboratories l
    ON r.lab_id = l.lab_id
JOIN workstations w
    ON r.station_id = w.station_id
    AND r.lab_id = w.lab_id
ORDER BY r.start_time ASC;

-- Beklenen sonuç:
-- 5 rezervasyon satırı gelmeli.


-- ============================================================
-- 3. GROUP BY İÇEREN SORGU
-- Amaç:
-- Her laboratuvar için toplam, aktif ve iptal edilmiş rezervasyon sayılarını göstermek.
-- Bu sorgu laboratuvar bazlı rezervasyon istatistiği üretir.
-- ============================================================

SELECT
    l.lab_id,
    l.lab_name,
    COUNT(r.reservation_id) AS total_reservation_count,
    SUM(CASE WHEN r.status = 'active' THEN 1 ELSE 0 END) AS active_reservation_count,
    SUM(CASE WHEN r.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_reservation_count
FROM laboratories l
LEFT JOIN reservations r
    ON l.lab_id = r.lab_id
GROUP BY
    l.lab_id,
    l.lab_name
ORDER BY
    total_reservation_count DESC,
    l.lab_name ASC;

-- Beklenen sonuç:
-- 4 laboratuvar satırı gelmeli.
-- Bilgisayar Mühendisliği Laboratuvarı toplam 2 rezervasyon göstermeli.


-- ============================================================
-- 4. TARİH FONKSİYONU İÇEREN SORGU
-- Amaç:
-- Rezervasyon tarihlerini formatlı göstermek ve rezervasyona kaç gün kaldığını hesaplamak.
-- DATE_FORMAT ve DATEDIFF tarih fonksiyonları kullanılmıştır.
-- ============================================================

SELECT
    reservation_id,
    DATE_FORMAT(start_time, '%d.%m.%Y') AS reservation_date,
    DATE_FORMAT(start_time, '%H:%i') AS start_hour,
    DATE_FORMAT(end_time, '%H:%i') AS end_hour,
    DATEDIFF(start_time, CURRENT_DATE()) AS days_left,
    status
FROM reservations
ORDER BY start_time ASC;

-- Beklenen sonuç:
-- 5 rezervasyon satırı gelmeli.
-- days_left değeri sorguyu çalıştırdığınız güne göre değişebilir.


-- ============================================================
-- 5. KARAKTER FONKSİYONU İÇEREN SORGU
-- Amaç:
-- Kullanıcı adını büyük harfle göstermek ve e-posta domain bilgisini ayırmak.
-- UPPER, CONCAT ve SUBSTRING_INDEX karakter fonksiyonları kullanılmıştır.
-- ============================================================

SELECT
    user_id,
    UPPER(CONCAT(first_name, ' ', last_name)) AS full_name_upper,
    email,
    SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM users
ORDER BY user_id ASC;

-- Beklenen sonuç:
-- 3 kullanıcı satırı gelmeli.
-- Örnek domainler:
-- lab.local
-- ogrenci.karabuk.edu.tr