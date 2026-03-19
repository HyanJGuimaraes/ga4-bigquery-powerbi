SELECT
  traffic_source.source AS fonte,
  traffic_source.medium AS midia,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos,
  COUNT(*) AS total_eventos,
  COUNTIF(event_name = 'session_start') AS sessoes,
  COUNTIF(event_name = 'purchase') AS compras,
  ROUND(COUNTIF(event_name = 'purchase') * 100.0 /
    NULLIF(COUNTIF(event_name = 'session_start'), 0), 2) AS taxa_conversao_pct
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
GROUP BY 1, 2
ORDER BY usuarios_unicos DESC
LIMIT 20
