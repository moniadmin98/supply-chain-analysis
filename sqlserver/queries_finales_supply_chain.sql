--DataCo Global Supply Chain - Análisis de Tiempos de Entrega e Impacto Económico

USE SupplyChainDataset;

select * from [dbo].DataCoSupplyChainDataset;

-- 1 ¿Cuál es el promedio de días reales de envío vs. los días programados, y cuál es la diferencia promedio?

--promedio de dias en los que tarda cada orden
with avg_days as (
select 
	AVG(CAST(days_for_shipping_real AS DECIMAL (10,2))) as avg_shipping_real,
	AVG(CAST(days_for_shipment_scheduled AS DECIMAL (10,2))) as avg_shipment_scheduled
from DataCoSupplyChainDataset
)
select 
	avg_shipping_real,
	avg_shipment_scheduled,
	(avg_shipping_real - avg_shipment_scheduled) AS difference_of_days
from avg_days;
GO

--2 ¿Cual es el porcentaje de ordenes que no cumplen con los días estimados de entrega? Excluyebdo los pedidos cancelados
--CONCLUSIÓN: 6 de cada 10 pedidos llegan tarde al cliente
SELECT
    SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) AS late_orders,
    COUNT(*) AS total_orders,
    CAST(SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL (10,2)) AS pct_late_orders
FROM DataCoSupplyChainDataset
WHERE Delivery_Status <> ( 'Shipping canceled')
;
GO 
--3 Regiones y lo porcentajes que presentan retrasos en los pedidos

CREATE INDEX IX_order_region
ON datacosupplychaindataset (order_region);
GO 

SELECT
    order_region,
    SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) AS late_orders,
    COUNT(*) AS total_orders,
    CAST(SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL (10,2)) AS pct_late_orders
FROM DataCoSupplyChainDataset
WHERE Delivery_Status <> 'Shipping canceled'
GROUP BY Order_Region
ORDER BY pct_late_orders DESC
;
GO 

--4 Analizando las Categorias(50) de productos para encontrar un factor categorico o sistemico en la deficiencia de entregas de productos
CREATE INDEX ID_category_name
ON DataCoSupplyChainDataset (category_name);
GO 
--
SELECT
    category_name,
    SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) AS late_orders,
    COUNT(*) AS total_orders,
    CAST(SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL (10,2)) AS pct_late_orders
FROM DataCoSupplyChainDataset
WHERE Delivery_Status <> 'Shipping canceled'
GROUP BY category_name
HAVING count(*) > 200
ORDER BY pct_late_orders DESC
;
GO 

-- 5.0 Clientes que ya no compraron desde la ultima cancelacion de su ultimo pedido

CREATE INDEX ID_date_orders
ON datacosupplychaindataset (order_date_dateorders);
GO 
---
WITH Customers_cancel AS (
        SELECT
            t1.order_customer_id,
            MAX(t1.order_date_dateorders) AS max_date_order,
            CASE WHEN EXISTS (
                             SELECT 1 
                             FROM DataCoSupplyChainDataset  t2
                             WHERE t2.order_customer_id =   t1.order_customer_id
                             AND t2.order_date_dateorders >  MAX(t1.order_date_dateorders)
                             ) THEN 1 ELSE 0 END AS new_orders
FROM DataCoSupplyChainDataset t1
WHERE Delivery_Status = 'Shipping canceled'
GROUP BY  t1.order_customer_id
HAVING MAX(t1.order_date_dateorders) <= DATEADD(MONTH, -6, (SELECT MAX(order_date_dateorders) FROM DataCoSupplyChainDataset))
 -- excluye clientes sin ventana de tiempo suficiente para volver a comprar
) 
SELECT 
    new_orders,
    COUNT(*) AS total_customers,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) AS porcentaje
FROM Customers_cancel
GROUP BY new_orders;
GO

--5.1 Cantidad de dinero que le costo a la empresa no mantener a esos clieentes

WITH Customers_cancel AS (
        SELECT
            t1.order_customer_id,
            MAX(t1.order_date_dateorders) AS max_date_order,
            CASE WHEN EXISTS (
                             SELECT 1 
                             FROM DataCoSupplyChainDataset  t2
                             WHERE t2.order_customer_id =   t1.order_customer_id
                             AND t2.order_date_dateorders >  MAX(t1.order_date_dateorders)
                             ) THEN 1 ELSE 0 END AS new_orders
FROM DataCoSupplyChainDataset t1
WHERE Delivery_Status = 'Shipping canceled'
GROUP BY  t1.order_customer_id
HAVING MAX(t1.order_date_dateorders) <= DATEADD(MONTH, -6, (SELECT MAX(order_date_dateorders) FROM DataCoSupplyChainDataset))
) -- excluye clientes sin ventana de tiempo suficiente para volver a comprar
SELECT 
    c.new_orders,
    COUNT(DISTINCT c.order_customer_id) AS total_customers,
    SUM(t.Order_Profit_Per_Order) AS total_revenue,
    CAST(AVG(t.Order_Profit_Per_Order) AS DECIMAL(10,2)) AS avg_profit_per_order
    --Promedio y suma de ganancia por orden de los cleintes que cancelaron
FROM Customers_cancel c
INNER JOIN DataCoSupplyChainDataset t ON c.order_customer_id = t.order_customer_id
GROUP BY c.new_orders;
GO 

--tabla para power bi

CREATE VIEW vw_PowerBI_SupplyChain AS
SELECT 
        Order_Id,
        days_for_shipping_real,
        days_for_shipment_scheduled,
        Delivery_Status,
        Order_Region,
        Market,
        Category_Name,
        Order_Customer_Id,
        order_date_dateorders,
        Order_Profit_Per_Order,
        Shipping_Mode,
        Customer_Segment
FROM DataCoSupplyChainDataset;
GO 
