"""Stock Market Analysis - live SQL playground (Streamlit).
Run:  pip install streamlit pandas plotly
      streamlit run app.py
CSV folder is preset to C:/Users/HP/Downloads/Stock_Project/data (editable in the sidebar)."""
import os, re, sqlite3
import pandas as pd
import plotly.graph_objects as go
import streamlit as st

st.set_page_config(page_title="SQL Stock Playground", layout="wide")
FILES = {"bajaj_auto": "Bajaj_Auto.csv", "eicher_motors": "Eicher_Motors.csv",
         "hero_motocorp": "Hero_Motocorp.csv", "infosys": "Infosys.csv",
         "tcs": "TCS.csv", "tvs_motors": "TVS_Motors.csv"}
COLS = ["date", "open_price", "high_price", "low_price", "close_price", "wap", "no_of_shares",
        "no_of_trades", "total_turnover", "deliverable_qty", "pct_deli_qty",
        "spread_high_low", "spread_close_open"]

PRESETS = {
 "Task 1: history length": "SELECT COUNT(*) AS trading_days, MIN(date) AS first_day, MAX(date) AS last_day\nFROM bajaj_auto;",
 "Task 2: Eicher top 5 closes": "SELECT date, close_price FROM eicher_motors ORDER BY close_price DESC LIMIT 5;",
 "Task 3: TCS yearly average": "SELECT strftime('%Y', date) AS year, ROUND(AVG(close_price),2) AS avg_close\nFROM tcs GROUP BY year ORDER BY year;",
 "Task 6: master view (all 6 merged)": "SELECT * FROM master_view;",
 "Task 5: Bajaj moving averages": "SELECT date, close_price, ma20, ma50 FROM bajaj1;",
 "Task 7/8: Bajaj signal counts": "SELECT signal, COUNT(*) AS days FROM bajaj2 GROUP BY signal ORDER BY signal;",
 "Task 9: signal on a date": "SELECT signal FROM bajaj2 WHERE date = '2018-06-21';",
 "Task 10: all six stocks summary": """SELECT stock,
       SUM(signal='Buy') AS buys, SUM(signal='Sell') AS sells, SUM(signal='Hold') AS holds
FROM all_signals GROUP BY stock ORDER BY stock;""",
 "Task 11: who went up (raw)": """WITH ends AS (SELECT stock, MIN(date) f, MAX(date) l FROM all_prices GROUP BY stock)
SELECT e.stock, a.close_price AS first_close, b.close_price AS last_close,
       ROUND(100.0*(b.close_price-a.close_price)/a.close_price,1) AS pct_change
FROM ends e JOIN all_prices a ON a.stock=e.stock AND a.date=e.f
            JOIN all_prices b ON b.stock=e.stock AND b.date=e.l
ORDER BY pct_change DESC;""",
 "Task 12: worst day per stock": """WITH m AS (
  SELECT stock, date, close_price,
         (close_price*1.0/LAG(close_price) OVER (PARTITION BY stock ORDER BY date)-1)*100 AS pct_move
  FROM all_prices),
r AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY stock ORDER BY pct_move) rn FROM m WHERE pct_move IS NOT NULL)
SELECT stock, date, close_price, ROUND(pct_move,1) AS pct_move FROM r WHERE rn=1 ORDER BY pct_move;""",
 "Task 13: adjusted % change (bonus fix)": """WITH adjusted AS (
  SELECT 'TCS' AS stock, date, CASE WHEN date < '2018-05-31' THEN close_price/2 ELSE close_price END AS adj_close FROM tcs
  UNION ALL
  SELECT 'Infosys', date, CASE WHEN date < '2015-06-15' THEN close_price/2 ELSE close_price END FROM infosys)
SELECT stock, ROUND(100.0*(MAX(CASE WHEN date='2018-07-31' THEN adj_close END)
                         / MAX(CASE WHEN date='2015-01-01' THEN adj_close END) - 1),1) AS adjusted_pct_change
FROM adjusted GROUP BY stock ORDER BY stock;""",
}

@st.cache_resource
def build_db(folder, short, long_):
    con = sqlite3.connect(":memory:", check_same_thread=False)
    for t, f in FILES.items():
        df = pd.read_csv(os.path.join(folder, f))
        df.columns = COLS
        df["date"] = pd.to_datetime(df["date"], format="%d-%B-%Y").dt.strftime("%Y-%m-%d")
        df.to_sql(t, con, index=False)
    names = {"Bajaj Auto": "bajaj_auto", "Eicher Motors": "eicher_motors", "Hero Motocorp": "hero_motocorp",
             "Infosys": "infosys", "TCS": "tcs", "TVS Motors": "tvs_motors"}
    union = " UNION ALL ".join(f"SELECT '{n}' AS stock, date, close_price FROM {t}" for n, t in names.items())
    con.executescript(f"""
    CREATE VIEW all_prices AS {union};
    CREATE VIEW master_view AS
      SELECT b.date, b.close_price AS bajaj, t.close_price AS tcs, v.close_price AS tvs,
             i.close_price AS infosys, e.close_price AS eicher, h.close_price AS hero
      FROM bajaj_auto b JOIN tcs t USING(date) JOIN tvs_motors v USING(date)
           JOIN infosys i USING(date) JOIN eicher_motors e USING(date) JOIN hero_motocorp h USING(date);
    CREATE TABLE bajaj1 AS
      SELECT date, close_price,
        CASE WHEN ROW_NUMBER() OVER (ORDER BY date) >= {short}
             THEN ROUND(AVG(close_price) OVER (ORDER BY date ROWS BETWEEN {short-1} PRECEDING AND CURRENT ROW),2) END AS ma20,
        CASE WHEN ROW_NUMBER() OVER (ORDER BY date) >= {long_}
             THEN ROUND(AVG(close_price) OVER (ORDER BY date ROWS BETWEEN {long_-1} PRECEDING AND CURRENT ROW),2) END AS ma50
      FROM bajaj_auto;
    CREATE TABLE bajaj2 AS
      WITH t AS (SELECT date, close_price, ma20, ma50,
                        LAG(ma20) OVER (ORDER BY date) AS p20, LAG(ma50) OVER (ORDER BY date) AS p50 FROM bajaj1)
      SELECT date, close_price,
        CASE WHEN ma20 IS NULL OR ma50 IS NULL OR p20 IS NULL OR p50 IS NULL THEN 'Hold'
             WHEN ma20 > ma50 AND p20 <= p50 THEN 'Buy'
             WHEN ma20 < ma50 AND p20 >= p50 THEN 'Sell' ELSE 'Hold' END AS signal
      FROM t;
    CREATE VIEW all_signals AS
      WITH ma AS (SELECT stock, date, close_price,
          CASE WHEN ROW_NUMBER() OVER w >= {short} THEN AVG(close_price) OVER (w ROWS BETWEEN {short-1} PRECEDING AND CURRENT ROW) END AS ma20,
          CASE WHEN ROW_NUMBER() OVER w >= {long_} THEN AVG(close_price) OVER (w ROWS BETWEEN {long_-1} PRECEDING AND CURRENT ROW) END AS ma50
        FROM all_prices WINDOW w AS (PARTITION BY stock ORDER BY date)),
      lg AS (SELECT *, LAG(ma20) OVER w AS p20, LAG(ma50) OVER w AS p50 FROM ma WINDOW w AS (PARTITION BY stock ORDER BY date))
      SELECT stock, date, close_price,
        CASE WHEN ma20 IS NULL OR ma50 IS NULL OR p20 IS NULL OR p50 IS NULL THEN 'Hold'
             WHEN ma20 > ma50 AND p20 <= p50 THEN 'Buy'
             WHEN ma20 < ma50 AND p20 >= p50 THEN 'Sell' ELSE 'Hold' END AS signal
      FROM lg;
    """)
    return con

st.title("📈 SQL Stock Market Playground")
st.caption("Write SQL live on 6 NSE stocks (2015-2018), see tables and charts instantly. Engine: SQLite (same logic as the MySQL file).")

with st.sidebar:
    st.header("Setup")
    default = os.environ.get("DATA_DIR") or "C:/Users/HP/Downloads/Stock_Project/data"
    folder = st.text_input("Folder with the 6 CSV files", default)
    short = st.number_input("Short MA window (days)", 2, 100, 20)
    long_ = st.number_input("Long MA window (days)", 3, 300, 50)
    st.markdown("**Tables:** bajaj_auto, eicher_motors, hero_motocorp, infosys, tcs, tvs_motors\n\n**Views/tables:** master_view, all_prices, all_signals, bajaj1, bajaj2")

if short >= long_:
    st.error("Short window must be smaller than long window."); st.stop()
try:
    con = build_db(folder, int(short), int(long_))
except Exception as e:
    st.error(f"Could not load CSVs from '{folder}'. Put the 6 files there. ({e})"); st.stop()

tab1, tab2, tab3 = st.tabs(["🧪 SQL Playground", "📊 Moving averages & signals", "🔗 Master view"])

with tab1:
    choice = st.selectbox("Pick a ready-made query (tasks from the guide) or write your own", ["(custom)"] + list(PRESETS))
    sql = st.text_area("SQL", PRESETS.get(choice, "SELECT * FROM bajaj_auto LIMIT 10;"), height=220, key=f"sql_{choice}")
    if st.button("▶ Run query", type="primary"):
        if not re.match(r"^\s*(select|with)\b", sql, re.I):
            st.error("Only SELECT / WITH queries are allowed here.")
        else:
            try:
                df = pd.read_sql_query(sql, con)
                st.success(f"{len(df)} rows")
                st.dataframe(df, width="stretch", height=330)
                num = df.select_dtypes("number").columns.tolist()
                if "date" in df.columns and num and len(df) > 1:
                    st.plotly_chart(go.Figure([go.Scatter(x=df["date"], y=df[c], name=c) for c in num[:6]]).update_layout(height=350), width="stretch")
                elif len(df) > 1 and num and df.shape[1] <= 4 and df.iloc[:, 0].dtype == object:
                    st.bar_chart(df.set_index(df.columns[0])[num])
            except Exception as e:
                st.error(f"SQL error: {e}")

with tab2:
    stock = st.selectbox("Stock", ["Bajaj Auto", "Eicher Motors", "Hero Motocorp", "Infosys", "TCS", "TVS Motors"])
    d = pd.read_sql_query("SELECT * FROM all_signals WHERE stock=? ORDER BY date", con, params=(stock,))
    d["short_ma"] = d.close_price.rolling(int(short)).mean(); d["long_ma"] = d.close_price.rolling(int(long_)).mean()
    fig = go.Figure()
    fig.add_scatter(x=d.date, y=d.close_price, name="Close", line=dict(color="grey", width=1))
    fig.add_scatter(x=d.date, y=d.short_ma, name=f"{int(short)}-day MA", line=dict(color="orange"))
    fig.add_scatter(x=d.date, y=d.long_ma, name=f"{int(long_)}-day MA", line=dict(color="royalblue"))
    for sg, sym, col in (("Buy", "triangle-up", "green"), ("Sell", "triangle-down", "red")):
        x = d[d.signal == sg]; fig.add_scatter(x=x.date, y=x.close_price, mode="markers", name=sg, marker=dict(symbol=sym, size=11, color=col))
    fig.update_layout(height=480, title=f"{stock}: golden-cross signals")
    st.plotly_chart(fig, width="stretch")
    c1, c2 = st.columns(2); c1.metric("Buys", int((d.signal == "Buy").sum())); c2.metric("Sells", int((d.signal == "Sell").sum()))
    if stock in ("TCS", "Infosys"):
        st.warning("⚠️ Raw prices: this stock had a 1:1 bonus issue (TCS 2018-05-31, Infosys 2015-06-15). The price cliff creates false signals. See Task 13.")

with tab3:
    m = pd.read_sql_query("SELECT * FROM master_view", con)
    st.write(f"{len(m)} rows: one row per date, closing price of all 6 stocks (INNER JOIN on date).")
    st.dataframe(m, width="stretch", height=300)
    norm = st.checkbox("Rebase to 100 (to compare)", True)
    cols = [c for c in m.columns if c != "date"]
    fig = go.Figure([go.Scatter(x=m.date, y=(m[c] / m[c].iloc[0] * 100 if norm else m[c]), name=c) for c in cols])
    st.plotly_chart(fig.update_layout(height=420), width="stretch")
