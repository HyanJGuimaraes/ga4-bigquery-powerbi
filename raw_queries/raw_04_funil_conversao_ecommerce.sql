SELECT 
  COUNTIF(event_name = 'view_item') AS visualizou_produto,
  COUNTIF(event_name = 'add_to_cart') AS adicionou_carrinho,
  COUNTIF(event_name = 'begin_checkout') AS iniciou_checkout,
  COUNTIF(event_name = 'purchase') AS finalizou_compra,
  ROUND(COUNTIF(event_name = 'add_to_cart') * 100.0 / 
    NULLIF(COUNTIF(event_name = 'view_item'), 0), 1) AS cvr_view_to_cart,
  ROUND(COUNTIF(event_name = 'begin_checkout') * 100.0 / 
    NULLIF(COUNTIF(event_name = 'add_to_cart'), 0), 1) AS cvr_cart_to_checkout,
  ROUND(COUNTIF(event_name = 'purchase') * 100.0 / 
    NULLIF(COUNTIF(event_name = 'begin_checkout'), 0), 1) AS cvr_checkout_to_purchase
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'