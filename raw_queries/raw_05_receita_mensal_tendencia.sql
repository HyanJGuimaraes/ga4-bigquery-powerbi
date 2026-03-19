SELECT
  FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', event_date)) AS mes,
  COUNT(DISTINCT user_pseudo_id) AS compradores,
  COUNT(DISTINCT transaction_id) AS pedidos,
  ROUND(SUM(ecommerce.purchase_revenue), 2) AS receita_total,
  ROUND(AVG(ecommerce.purchase_revenue), 2) AS ticket_medio
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST([STRUCT(
    (SELECT value.string_value FROM UNNEST(event_params)
    WHERE key = 'transaction_id') AS transaction_id
  )])
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
  AND event_name = 'purchase'
GROUP BY 1
ORDER BY 1