CREATE OR REPLACE VIEW `portfolio-ga4-bi.ga4_gold.vw_trafego_por_canal` AS
SELECT
  COALESCE(traffic_source.source, '(direct)') AS fonte,
  COALESCE(traffic_source.medium, '(none)') AS midia,
  CONCAT(
    COALESCE(traffic_source.source, '(direct)'), ' / ',
    COALESCE(traffic_source.medium, '(none)')
  ) AS canal,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos,
  COUNTIF(event_name = 'session_start') AS sessoes,
  COUNTIF(event_name = 'purchase') AS compras,
  ROUND(COUNTIF(event_name = 'purchase') * 100.0 / 
    NULLIF(COUNTIF(event_name = 'session_start'), 0), 2) AS taxa_conversao_pct,
  ROUND(SUM(ecommerce.purchase_revenue), 2) AS receita_total
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY 1, 2, 3