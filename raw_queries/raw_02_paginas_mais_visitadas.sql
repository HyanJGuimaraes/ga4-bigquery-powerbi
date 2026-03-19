SELECT
  (SELECT value.string_value FROM UNNEST(event_params)
  WHERE key = 'page_title') AS titulo_pagina,
  (SELECT value.string_value FROM UNNEST(event_params)
  WHERE key = 'page_location') AS url_pagina,
  COUNT(*) AS visualizacoes,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos,
  ROUND(AVG(
    (SELECT value.int_value FROM UNNEST(event_params)
    WHERE key = 'engagement_time_msec')
  ) / 1000,1) AS tempo_medio_seg
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
  AND event_name = 'page_view'
GROUP BY 1, 2
ORDER BY visualizacoes DESC
LIMIT 20