CREATE OR REPLACE VIEW `portfolio-ga4-bi.ga4_gold.vw_receita_mensal` AS
WITH base AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', event_date)) AS mes,
    user_pseudo_id,
    ecommerce.transaction_id AS transaction_id,
    ecommerce.purchase_revenue AS receita
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND ecommerce.purchase_revenue > 0
)
SELECT
  mes,
  COUNT(DISTINCT transaction_id) AS pedidos,
  COUNT(DISTINCT user_pseudo_id) AS compradores,
  ROUND(SUM(receita), 2) AS receita_total,
  ROUND(AVG(receita), 2) AS ticket_medio,
  LAG(ROUND(SUM(receita), 2)) OVER (ORDER BY mes) AS receita_mes_anterior,
  ROUND((SUM(receita) - LAG(SUM(receita)) OVER (ORDER BY mes)) * 100.0 /
    NULLIF(LAG(SUM(receita)) OVER (ORDER BY mes), 0), 1) AS variacao_mom_pct
FROM base
GROUP BY mes
ORDER BY mes