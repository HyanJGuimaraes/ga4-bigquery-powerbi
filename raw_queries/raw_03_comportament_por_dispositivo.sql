SELECT
  device.category AS dispositivo,
  device.operating_system AS sistema_op,
  COUNT(DISTINCT user_pseudo_id) AS usuarios,
  COUNTIF(event_name = 'session_start') AS sessoes,
  COUNTIF(event_name = 'purchase') AS compras,
  SUM(ecommerce.purchase_revenue) AS receita_total,
  ROUND(AVG(ecommerce.purchase_revenue), 2) AS ticket_medio
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
  AND event_name IN ('session_start', 'purchase')
GROUP BY 1, 2
ORDER BY usuarios DESC