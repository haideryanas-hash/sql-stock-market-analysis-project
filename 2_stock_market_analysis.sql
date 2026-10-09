-- =========================================================
-- FILE 2 of 2: the analysis (Tasks 1 to 13 + stretch)
-- Run 1_load_data.sql first. Then run this file whole, or one query at a time
-- (click inside a query and press Ctrl+Enter).
-- =========================================================
USE stock_analysis;


-- =========================================================
-- PART 1: GET TO KNOW THE DATA
-- =========================================================

-- Task 1: How much history do we have? (plus columns, data types, row counts)
DESCRIBE bajaj_auto;   -- column names and data types (all six tables share the same layout)


SELECT 'bajaj_auto' AS stock, COUNT(*) AS trading_days, MIN(`date`) AS first_day, MAX(`date`) AS last_day FROM bajaj_auto
UNION ALL SELECT 'eicher_motors', COUNT(*), MIN(`date`), MAX(`date`) FROM eicher_motors
UNION ALL SELECT 'hero_motocorp', COUNT(*), MIN(`date`), MAX(`date`) FROM hero_motocorp
UNION ALL SELECT 'infosys',       COUNT(*), MIN(`date`), MAX(`date`) FROM infosys
UNION ALL SELECT 'tcs',           COUNT(*), MIN(`date`), MAX(`date`) FROM tcs
UNION ALL SELECT 'tvs_motors',    COUNT(*), MIN(`date`), MAX(`date`) FROM tvs_motors;


-- Task 2: Eicher's five best closes
SELECT `date`, close_price
FROM eicher_motors
ORDER BY close_price DESC
LIMIT 5;


-- Task 3: TCS, year by year
SELECT YEAR(`date`) AS year,
       ROUND(AVG(close_price), 2) AS avg_close
FROM tcs
GROUP BY YEAR(`date`)
ORDER BY year;


-- Task 4: Find the holes. Step A: NULL count in EVERY column of all six tables
SELECT 'bajaj_auto' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM bajaj_auto
UNION ALL
SELECT 'eicher_motors' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM eicher_motors
UNION ALL
SELECT 'hero_motocorp' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM hero_motocorp
UNION ALL
SELECT 'infosys' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM infosys
UNION ALL
SELECT 'tcs' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM tcs
UNION ALL
SELECT 'tvs_motors' AS stock, SUM(`date` IS NULL) AS date_nulls, SUM(open_price IS NULL) AS open_price_nulls, SUM(high_price IS NULL) AS high_price_nulls, SUM(low_price IS NULL) AS low_price_nulls, SUM(close_price IS NULL) AS close_price_nulls, SUM(wap IS NULL) AS wap_nulls, SUM(no_of_shares IS NULL) AS no_of_shares_nulls, SUM(no_of_trades IS NULL) AS no_of_trades_nulls, SUM(total_turnover IS NULL) AS total_turnover_nulls, SUM(deliverable_qty IS NULL) AS deliverable_qty_nulls, SUM(pct_deli_qty IS NULL) AS pct_deli_qty_nulls, SUM(spread_high_low IS NULL) AS spread_high_low_nulls, SUM(spread_close_open IS NULL) AS spread_close_open_nulls FROM tvs_motors;
-- Result: only deliverable_qty has NULLs, one per stock. Do NOT fill with 0 or the average.


-- Step B: which dates are they?
SELECT 'bajaj_auto'    AS stock, `date` FROM bajaj_auto    WHERE deliverable_qty IS NULL
UNION ALL
SELECT 'eicher_motors' AS stock, `date` FROM eicher_motors WHERE deliverable_qty IS NULL
UNION ALL
SELECT 'hero_motocorp' AS stock, `date` FROM hero_motocorp WHERE deliverable_qty IS NULL
UNION ALL
SELECT 'infosys'       AS stock, `date` FROM infosys       WHERE deliverable_qty IS NULL
UNION ALL
SELECT 'tcs'           AS stock, `date` FROM tcs           WHERE deliverable_qty IS NULL
UNION ALL
SELECT 'tvs_motors'    AS stock, `date` FROM tvs_motors    WHERE deliverable_qty IS NULL;


-- =========================================================
-- PART 2: THE ASSIGNMENT
-- =========================================================

-- Task 5: Moving averages for Bajaj Auto -> bajaj1
-- ma20 = avg of today + previous 19 days (frame of 20 rows), NULL until row 20
-- ma50 = avg of today + previous 49 days (frame of 50 rows), NULL until row 50
DROP TABLE IF EXISTS bajaj1;


CREATE TABLE bajaj1 AS
SELECT
    `date`,
    close_price,
    CASE WHEN ROW_NUMBER() OVER (ORDER BY `date`) >= 20
         THEN ROUND(AVG(close_price) OVER (ORDER BY `date`
                    ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), 2)
    END AS ma20,
    CASE WHEN ROW_NUMBER() OVER (ORDER BY `date`) >= 50
         THEN ROUND(AVG(close_price) OVER (ORDER BY `date`
                    ROWS BETWEEN 49 PRECEDING AND CURRENT ROW), 2)
    END AS ma50
FROM bajaj_auto;


-- Task 6: Master table (one row per date, closing price of every stock)
DROP TABLE IF EXISTS master_table;


CREATE TABLE master_table AS
SELECT b.`date`,
       b.close_price AS bajaj,
       t.close_price AS tcs,
       v.close_price AS tvs,
       i.close_price AS infosys,
       e.close_price AS eicher,
       h.close_price AS hero
FROM bajaj_auto b
JOIN tcs           t ON t.`date` = b.`date`
JOIN tvs_motors    v ON v.`date` = b.`date`
JOIN infosys       i ON i.`date` = b.`date`
JOIN eicher_motors e ON e.`date` = b.`date`
JOIN hero_motocorp h ON h.`date` = b.`date`;


-- Same thing as a VIEW (always live, stores no copy of the data)
CREATE OR REPLACE VIEW master_view AS
SELECT b.`date`,
       b.close_price AS bajaj,   t.close_price AS tcs,     v.close_price AS tvs,
       i.close_price AS infosys, e.close_price AS eicher,  h.close_price AS hero
FROM bajaj_auto b
JOIN tcs           t ON t.`date` = b.`date`
JOIN tvs_motors    v ON v.`date` = b.`date`
JOIN infosys       i ON i.`date` = b.`date`
JOIN eicher_motors e ON e.`date` = b.`date`
JOIN hero_motocorp h ON h.`date` = b.`date`;


-- Task 7: Golden-cross signals for Bajaj Auto -> bajaj2
-- Buy  = ma20 crosses ABOVE ma50 today (yesterday ma20 <= ma50)
-- Sell = ma20 crosses BELOW ma50 today (yesterday ma20 >= ma50)
-- Hold = everything else, including days with NULL averages
DROP TABLE IF EXISTS bajaj2;


CREATE TABLE bajaj2 AS
WITH t AS (
    SELECT `date`, close_price, ma20, ma50,
           LAG(ma20) OVER (ORDER BY `date`) AS prev_ma20,
           LAG(ma50) OVER (ORDER BY `date`) AS prev_ma50
    FROM bajaj1
)
SELECT `date`, close_price,
       CASE
           WHEN ma20 IS NULL OR ma50 IS NULL
             OR prev_ma20 IS NULL OR prev_ma50 IS NULL THEN 'Hold'
           WHEN ma20 > ma50 AND prev_ma20 <= prev_ma50 THEN 'Buy'
           WHEN ma20 < ma50 AND prev_ma20 >= prev_ma50 THEN 'Sell'
           ELSE 'Hold'
       END AS `signal`
FROM t;


-- Task 8: How often did it trigger?
SELECT `signal`, COUNT(*) AS days
FROM bajaj2
GROUP BY `signal`
ORDER BY `signal`;


-- Task 9: Signal on a given day
SELECT `signal` FROM bajaj2 WHERE `date` = '2018-06-21';


DROP FUNCTION IF EXISTS bajaj_signal;


DELIMITER $$
CREATE FUNCTION bajaj_signal(d DATE)
RETURNS VARCHAR(4) DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE s VARCHAR(4);
    SELECT `signal` INTO s FROM bajaj2 WHERE `date` = d;
    RETURN s;    -- NULL if the market was closed / date not in table
END $$
DELIMITER ;


SELECT bajaj_signal('2015-05-18') AS buy_day,      -- check: Buy
       bajaj_signal('2016-01-04') AS hold_day,     -- check: Hold
       bajaj_signal('2018-06-21') AS asked_day,
       bajaj_signal('2018-06-24') AS sunday_null;  -- NULL: closed market


-- Task 10: All six stocks in one query (buys, sells, holds, latest signal)
-- Uses UNROUNDED averages, and PARTITION BY stock in every window.
WITH prices AS (
    SELECT 'Bajaj Auto'    AS stock, `date`, close_price FROM bajaj_auto
    UNION ALL SELECT 'Eicher Motors', `date`, close_price FROM eicher_motors
    UNION ALL SELECT 'Hero Motocorp', `date`, close_price FROM hero_motocorp
    UNION ALL SELECT 'Infosys',       `date`, close_price FROM infosys
    UNION ALL SELECT 'TCS',           `date`, close_price FROM tcs
    UNION ALL SELECT 'TVS Motors',    `date`, close_price FROM tvs_motors
),
ma AS (
    SELECT stock, `date`, close_price,
           CASE WHEN ROW_NUMBER() OVER (PARTITION BY stock ORDER BY `date`) >= 20
                THEN AVG(close_price) OVER (PARTITION BY stock ORDER BY `date`
                     ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END AS ma20,
           CASE WHEN ROW_NUMBER() OVER (PARTITION BY stock ORDER BY `date`) >= 50
                THEN AVG(close_price) OVER (PARTITION BY stock ORDER BY `date`
                     ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END AS ma50
    FROM prices
),
lagged AS (
    SELECT stock, `date`, close_price, ma20, ma50,
           LAG(ma20) OVER (PARTITION BY stock ORDER BY `date`) AS prev_ma20,
           LAG(ma50) OVER (PARTITION BY stock ORDER BY `date`) AS prev_ma50
    FROM ma
),
sig AS (
    SELECT stock, `date`, close_price,
           CASE
               WHEN ma20 IS NULL OR ma50 IS NULL
                 OR prev_ma20 IS NULL OR prev_ma50 IS NULL THEN 'Hold'
               WHEN ma20 > ma50 AND prev_ma20 <= prev_ma50 THEN 'Buy'
               WHEN ma20 < ma50 AND prev_ma20 >= prev_ma50 THEN 'Sell'
               ELSE 'Hold'
           END AS `signal`
    FROM lagged
),
latest AS (
    SELECT stock, `date`, `signal`,
           ROW_NUMBER() OVER (PARTITION BY stock ORDER BY `date` DESC) AS rn
    FROM sig
    WHERE `signal` <> 'Hold'
)
SELECT s.stock,
       SUM(s.`signal` = 'Buy')  AS buys,
       SUM(s.`signal` = 'Sell') AS sells,
       SUM(s.`signal` = 'Hold') AS holds,
       l.`date`   AS last_signal_date,
       l.`signal` AS last_signal
FROM sig s
JOIN latest l ON l.stock = s.stock AND l.rn = 1
GROUP BY s.stock, l.`date`, l.`signal`
ORDER BY s.stock;


-- =========================================================
-- PART 3: QUESTION THE RESULT
-- =========================================================

-- Task 11: Who went up? (first vs last trading day, raw prices)
WITH prices AS (
    SELECT 'Bajaj Auto'    AS stock, `date`, close_price FROM bajaj_auto
    UNION ALL SELECT 'Eicher Motors', `date`, close_price FROM eicher_motors
    UNION ALL SELECT 'Hero Motocorp', `date`, close_price FROM hero_motocorp
    UNION ALL SELECT 'Infosys',       `date`, close_price FROM infosys
    UNION ALL SELECT 'TCS',           `date`, close_price FROM tcs
    UNION ALL SELECT 'TVS Motors',    `date`, close_price FROM tvs_motors
),
ends AS (
    SELECT stock, MIN(`date`) AS first_day, MAX(`date`) AS last_day
    FROM prices GROUP BY stock
)
SELECT e.stock,
       f.close_price AS first_close,
       l.close_price AS last_close,
       ROUND(100.0 * (l.close_price - f.close_price) / f.close_price, 1) AS pct_change
FROM ends e
JOIN prices f ON f.stock = e.stock AND f.`date` = e.first_day
JOIN prices l ON l.stock = e.stock AND l.`date` = e.last_day
ORDER BY pct_change DESC;


-- Task 12: The data trap - each stock's single worst day
WITH prices AS (
    SELECT 'Bajaj Auto'    AS stock, `date`, close_price FROM bajaj_auto
    UNION ALL SELECT 'Eicher Motors', `date`, close_price FROM eicher_motors
    UNION ALL SELECT 'Hero Motocorp', `date`, close_price FROM hero_motocorp
    UNION ALL SELECT 'Infosys',       `date`, close_price FROM infosys
    UNION ALL SELECT 'TCS',           `date`, close_price FROM tcs
    UNION ALL SELECT 'TVS Motors',    `date`, close_price FROM tvs_motors
),
moves AS (
    SELECT stock, `date`, close_price,
           (close_price / LAG(close_price) OVER (PARTITION BY stock ORDER BY `date`) - 1) * 100 AS pct_move
    FROM prices
),
ranked AS (
    SELECT stock, `date`, close_price, pct_move,
           ROW_NUMBER() OVER (PARTITION BY stock ORDER BY pct_move ASC) AS rn
    FROM moves
    WHERE pct_move IS NOT NULL
)
SELECT stock, `date`, close_price, ROUND(pct_move, 1) AS pct_move
FROM ranked
WHERE rn = 1
ORDER BY pct_move;
-- FINDING: Infosys 2015-06-15 (-49.9%) and TCS 2018-05-31 (-50.4%) are NOT crashes.
-- Both are 1:1 bonus issues (share count doubled, price halved). The price series
-- is unadjusted, so it has a fake "cliff" on those two dates.


-- Task 13: Fix it - adjust for the 1:1 bonus issues, then re-measure
--   TCS      bonus 1:1, first day at new price = 2018-05-31
--   Infosys  bonus 1:1, first day at new price = 2015-06-15
WITH adjusted AS (
    SELECT 'TCS' AS stock, `date`,
           CASE WHEN `date` < '2018-05-31' THEN close_price / 2 ELSE close_price END AS adj_close
    FROM tcs
    UNION ALL
    SELECT 'Infosys' AS stock, `date`,
           CASE WHEN `date` < '2015-06-15' THEN close_price / 2 ELSE close_price END AS adj_close
    FROM infosys
)
SELECT stock,
       ROUND(100.0 * (MAX(CASE WHEN `date` = '2018-07-31' THEN adj_close END)
                    / MAX(CASE WHEN `date` = '2015-01-01' THEN adj_close END) - 1), 1)
           AS adjusted_pct_change
FROM adjusted
GROUP BY stock
ORDER BY stock;


-- Stretch: rebuild signals for TCS and Infosys on ADJUSTED prices and compare
-- with the raw-price signals (which one was created purely by the cliff?)
WITH base AS (
    SELECT 'TCS' AS stock, `date`, close_price AS raw_close,
           CASE WHEN `date` < '2018-05-31' THEN close_price / 2 ELSE close_price END AS adj_close
    FROM tcs
    UNION ALL
    SELECT 'Infosys', `date`, close_price,
           CASE WHEN `date` < '2015-06-15' THEN close_price / 2 ELSE close_price END
    FROM infosys
),
ma AS (
    SELECT stock, `date`,
           CASE WHEN ROW_NUMBER() OVER w >= 50 THEN AVG(raw_close) OVER (w ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END AS r50,
           CASE WHEN ROW_NUMBER() OVER w >= 20 THEN AVG(raw_close) OVER (w ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END AS r20,
           CASE WHEN ROW_NUMBER() OVER w >= 50 THEN AVG(adj_close) OVER (w ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END AS a50,
           CASE WHEN ROW_NUMBER() OVER w >= 20 THEN AVG(adj_close) OVER (w ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END AS a20
    FROM base
    WINDOW w AS (PARTITION BY stock ORDER BY `date`)
),
lg AS (
    SELECT *, LAG(r20) OVER w AS pr20, LAG(r50) OVER w AS pr50,
              LAG(a20) OVER w AS pa20, LAG(a50) OVER w AS pa50
    FROM ma
    WINDOW w AS (PARTITION BY stock ORDER BY `date`)
),
sg AS (
    SELECT stock, `date`,
           CASE WHEN r20 IS NULL OR r50 IS NULL OR pr20 IS NULL OR pr50 IS NULL THEN 'Hold'
                WHEN r20 > r50 AND pr20 <= pr50 THEN 'Buy'
                WHEN r20 < r50 AND pr20 >= pr50 THEN 'Sell' ELSE 'Hold' END AS raw_signal,
           CASE WHEN a20 IS NULL OR a50 IS NULL OR pa20 IS NULL OR pa50 IS NULL THEN 'Hold'
                WHEN a20 > a50 AND pa20 <= pa50 THEN 'Buy'
                WHEN a20 < a50 AND pa20 >= pa50 THEN 'Sell' ELSE 'Hold' END AS adj_signal
    FROM lg
)
-- every date where the two versions disagree, or where either has a signal
SELECT stock, `date`, raw_signal, adj_signal,
       CASE WHEN raw_signal = adj_signal THEN 'same'
            WHEN adj_signal = 'Hold'     THEN 'raw-only (created by the cliff)'
            WHEN raw_signal = 'Hold'     THEN 'adjusted-only (hidden by the cliff)'
            ELSE 'differs' END AS comparison
FROM sg
WHERE raw_signal <> 'Hold' OR adj_signal <> 'Hold'
ORDER BY stock, `date`;
