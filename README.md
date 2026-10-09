# SQL Stock Market Analysis

Analysis of six NSE stocks (Bajaj Auto, Eicher Motors, Hero MotoCorp, Infosys, TCS, TVS Motors) from 1 Jan 2015 to 31 Jul 2018, done in **MySQL 8**. The project builds 20-day and 50-day moving averages, generates Buy / Sell / Hold signals from crossovers, and then questions the result: it finds that TCS and Infosys had **1:1 bonus issues** that make the raw prices look like 50% crashes, and fixes the data.

## Key findings
- Every table has 889 trading days. The only NULLs are in `deliverable_qty` (one row per stock), left as NULL on purpose.
- Raw prices show TCS at -23.8% and Infosys at -30.9%. After adjusting for the bonus issues (TCS ex-date 31 May 2018, Infosys ex-date 15 Jun 2015), TCS is **+52.4%** and Infosys **+38.2%**.
- The price cliffs created false signals (for example TCS's Sell on 5 Jun 2018) and hid real ones (three Infosys signals in Jul 2015).
- Latest signals on adjusted prices: **Buy** for Bajaj Auto, Infosys and TCS; **Sell** for Eicher Motors, Hero MotoCorp and TVS Motors.
- Short signals that reversed within weeks mostly lost money (roughly 3 to 8% each).

These are descriptive results on past data, not investment advice. Dividends, brokerage costs, taxes and news are not included.

## Files
| File | Purpose |
|---|---|
| `1_load_data.sql` | Creates the database and tables and loads the data (run first) |
| `2_stock_market_analysis.sql` | Full analysis, Tasks 1 to 13 plus a stretch task (14 result sets) |
| `Stock_Market_Insights.pdf` | Insights report with charts |
| `app.py`, `requirements.txt` | Streamlit live SQL playground |
| `data/` | The six source CSV files (optional) |

## SQL techniques used
Window functions (`AVG() OVER`, `LAG()`, `ROW_NUMBER()`), `PARTITION BY`, CTEs, `UNION ALL`, joins, `CASE`, `CREATE TABLE AS`, views, and a user-defined function.

## How to run

**MySQL (8.0 or higher):**
1. Run `1_load_data.sql`. Each table should show 889 rows.
2. Run `2_stock_market_analysis.sql`, either whole or one query at a time.

**Streamlit playground:**
```
pip install -r requirements.txt
python -m streamlit run app.py
```
Put the six CSV files in a folder and enter its path in the app's sidebar (the default path in `app.py` points to the author's computer).
