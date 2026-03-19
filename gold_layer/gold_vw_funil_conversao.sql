CREATE OR REPLACE VIEW `portfolio-ga4-bi.ga4_gold.vw_funil_conversao` AS
WITH funil AS (
 SELECT
 COUNTIF(event_name = 'view_item') AS visualizou_produto,
 COUNTIF(event_name = 'add_to_cart') AS adicionou_carrinho,
 COUNTIF(event_name = 'begin_checkout') AS iniciou_checkout,
 COUNTIF(event_name = 'purchase') AS finalizou_compra
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
 WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
 1 AS ordem, 'Visualizou Produto' AS etapa, visualizou_produto AS usuarios,
 100.0 AS taxa_retencao_pct FROM funil
UNION ALL SELECT 2, 'Adicionou ao Carrinho', adicionou_carrinho,
 ROUND(adicionou_carrinho * 100.0 / visualizou_produto, 1) FROM funil
UNION ALL SELECT 3, 'Iniciou Checkout', iniciou_checkout,
 ROUND(iniciou_checkout * 100.0 / visualizou_produto, 1) FROM funil
UNION ALL SELECT 4, 'Finalizou Compra', finalizou_compra,
 ROUND(finalizou_compra * 100.0 / visualizou_produto, 1) FROM funil
ORDER BY ordem