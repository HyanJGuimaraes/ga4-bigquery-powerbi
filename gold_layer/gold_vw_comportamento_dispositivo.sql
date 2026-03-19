CREATE OR REPLACE VIEW `portfolio-ga4-bi.ga4_gold.vw_comportamento_dispositivo` AS
SELECT
  device.category AS dispositivo,
  device.operating_system AS sistema_op,
  COUNT(DISTINCT user_pseudo_id) AS usuarios,
  COUNTIF(event_name = 'session_start') AS sessoes,
  COUNTIF(event_name = 'purchase') AS compras,
  ROUND(SUM(ecommerce.purchase_revenue), 2) AS receita_total,
  ROUND(AVG(ecommerce.purchase_revenue), 2) AS ticket_medio,
  ROUND(COUNTIF(event_name = 'purchase') * 100.0 /
    NULLIF(COUNTIF(event_name = 'session_start'), 0), 2) AS taxa_conversao_pct
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name IN ('session_start', 'purchase')
GROUP BY 1, 2
ORDER BY usuarios DESC