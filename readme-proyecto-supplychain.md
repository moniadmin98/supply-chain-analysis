# DataCo Global Supply Chain — Análisis de Tiempos de Entrega e Impacto Económico

## 1.0 Resumen del proyecto

Análisis de los tiempos de entrega de la cadena de suministro de DataCo
Global y el impacto que tiene la retención o la no retención de clientes
en el aspecto económico de la empresa, utilizando SQL Server y Power BI.
Se identificó un alto porcentaje de pedidos entregados en estado
retrasado, por lo que fue necesario encontrar la posible causa raíz para
entender si se trata de un problema directamente del proceso de entregas
o es un problema aislado por algún factor diferente.

## 2.0 Problema de negocio

La empresa DataCo Global se dedica a la comercialización de diferentes
equipos para deporte y fitness, como calzado, vestimenta, relojes, entre
otros. Dicha empresa vende en muchos países en todos los continentes.

Cuando se realizó una búsqueda exploratoria en los días reales y los
días programados de envió de los productos, se obtuvieron promedios y se
observó que los días reales sobrepasaban los días programados, es
importante tener un control de este proceso final de la cadena de
suministro de una empresa y poder medir el impacto real y futuro que
tiene en la empresa al no cumplir con estos tiempos.

## 3.0 Fuente de datos

Nombre del dataset**:** **DataCo Smart Supply Chain for Big Data
Analysis**

Link:<https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis>

El dataset principal contiene 180,519 filas en total, cada fila
representa un Order_item que contiene un producto especifico que forma
parte de una orden completa.

Los rangos de fecha del análisis comprenden desde 2015-01-01 a
2018-01-31, la carpeta del dataset contiene 3 archivos, pero se
descartaron 2: tokenized_access_logs.csv (datos de
clickstream/navegación web son datos que no están ligados al análisis) y
DescriptionDataCoSupplyChain.csv (contiene la descripción de las
columnas del archivo principal) y sirvió como referencia para entender
el contexto de negocio.

## 4.0 Herramientas utilizadas

SQL Server / SSMS, Power BI Desktop, DAX, Git/GitHub

## 5.0 Metodología empleada

El análisis se proyectó para responder al menos 5 preguntas que
surgieran a partir del análisis exploratorio, con una tabla general de
las actividades de la empresa se seleccionaron sólo las columnas que
estaban involucradas en las preguntas de negocio.  
Los resultados de las preguntas dieron lugar a que no fuera necesario un
análisis con un grado de granularidad muy profundo.

Al finalizar con las 5 preguntas respondidas se dió paso a realizar la
visualización mediante un Dashboard en Power BI, para poder hacerlo se
creó una Vista en SQl Server y así poder extraer las columnas que están
involucradas en el análisis y también unas columnas que ayudan a
mantener la interactividad con el Dashboard como resultados por Mercado,
método de compra, etc.

Fue necesario la creación de medidas DAX de las columnas que son
calculadas, así como en SQL Server.

## 6.0 Preguntas de negocio y hallazgos

1.0 ¿Cuál es el promedio de días reales de envío vs. días programados y
cuál es la diferencia entre promedios?

<img src="./images/image1.png" style="width:5.54861in;height:1.5625in" />

1.1 Resultado

<img src="./images/image2.png"
style="width:3.96548in;height:0.44447in" />

1.2 Hallazgo

El resultado muestra que el promedio de días reales es mayor que los
días programados de entrega, esto significa que la mayoría de los
pedidos llegan poco más de medio día tarde en ser entregados a los
clientes, esto nos dice que hay una seria deficiencia en esa etapa de la
cadena de suministros de la empresa en su etapa final.

2.0 ¿Cuál es el porcentaje de ordenes que no cumplen con los días
estimados de entrega? Excluyendo los pedidos cancelados

<img src="./images/image3.png"
style="width:6.94028in;height:0.87014in" />

2.1 Resultado

<img src="./images/image4.png" style="width:2.81959in;height:0.4653in" />

2.2 Hallazgo

Del total de las ordenes se filtran solo las que no han sido canceladas
lo que da como resultado un 57.29% de ordenes marcadas como
“Retrasadas”, si se aproxima el resultado se pude concluir que para la
empresa: **“6 de cada 10 clientes reciben su pedido tarde”**. Esto abre
la puerta a la próxima pregunta, se debe evaluar granularidad y poder
encontrar la causa raíz del problema de entregas.

3.0 ¿Cuáles son las regiones que presentan más ordenes retrasadas?

<img src="./images/image5.png"
style="width:6.64722in;height:1.00972in" />

3.1 Resultado

<img src="./images/image6.png" style="width:3.60435in;height:4.278in" />

3.2 Hallazgo

En esta consulta se observa el conteo de ordenes por región ordenadas
por el porcentaje de órdenes que llegan con retraso del total hechas,
esto responde a la interrogante, no hay 1 o 5 regiones de las 23 que
tengan en su mayoría ordenes entregadas retrasadas, es un problema
sistémico del proceso de entrega, no hay una sola región que se dispare
en los datos, todas las regiones tienen entregas retrasadas entre del
50%-60%.

Este resultado permite ahora buscar otra posible causa.

4.0 ¿Cuáles son las Categorías de Productos que presentan un mayor
número de ordenes retrasadas?

<img src="./images/image7.png" style="width:6.5in;height:1.075in" />

4.1 Resultado

<img src="./images/image8.png"
style="width:2.96543in;height:4.52801in" />
<img src="./images/image9.png"
style="width:3.00694in;height:1.79167in" />

4.2 Hallazgo

Al escribir la consulta se filtró con HAVING sólo a las categorías que
tuvieran un pedido mayor a 200, utilizando un volumen confiable, como
resultado se obtuvo el mismo patrón que en la pregunta anterior con las
regiones, el problema radica en el proceso de envío de manera
generalizado. Los porcentajes rondan de 49% a 63%.

Para finalizar es importante evaluar el impacto que tiene para la
empresa esos retrasos, analizando a esos clientes que cancelaron sus
pedidos porque sobrepasó el tiempo estimado y ya no volvieron a comprar
desde su último pedido, se consideró razonable un tiempo de 6 meses
después de la última orden cancelada, es un tiempo prudente para
realizar otro pedido.

5.0 ¿Cuántos clientes ya no volvieron a comprar desde su último pedido
cancelado?

<img src="./images/image10.png" style="width:6.5in;height:2.47778in" />
5.1 Resultado

<img src="./images/image11.png"
style="width:2.62513in;height:0.61114in" />

5.2 Hallazgo

El resultado indica el total de clientes que tuvieron su cancelación 6
meses antes de la fecha final del dataset (2018-01-31) que fueron 2,118,
de esos 391 no volvieron a realizar una orden, aproximando el porcentaje
con 20% se concluye que **“1 de cada 5 clientes no vuelve a comprar”** a
simple vista no es muy impactante este dato por tal motivo debe
analizarse en términos económicos para la empresa.

5.3 ¿Cuánto es la cantidad de dinero que le costó a la empresa no
mantener a esos clientes?

<img src="./images/image12.png" style="width:6.5in;height:2.71875in" />

5.4 Resultado

<img src="./images/image13.png"
style="width:4.29883in;height:0.62503in" />

5.5 Hallazgo

Esos 391 clientes representaban \$103,954.53 en ganancia histórica para
la empresa, con un valor promedio por pedido de \$20.04 casi idéntico al
de los clientes retenidos (\$21.30), se concluye que estos clientes
perdidos no eran clientes de bajo valor.  
Es importante aplicar una estrategia para mejorar los tiempos de entrega
y evitar pérdidas de nuevos clientes.

**Nota:** Sobre variación de cifras: los valores mostrados en este
dashboard (calculados en DAX) presentan una variación mínima respecto a
los resultados obtenidos originalmente en SQL Server 2,116 vs. 2,118
clientes con cancelación, y \$103,637.85 vs. \$103,954.53 en ganancia.
Esta diferencia de 0.09% se debe al manejo distinto de casos límite de
fecha/hora entre las funciones DATEADD (SQL) y EDATE (DAX) al calcular
la ventana de 6 meses. No afecta las conclusiones del análisis.

## 7.0 Visualización de Dashboard

<img src="./images/image14.png" style="width:6.5in;height:3.65347in" />

El Dashboard permite filtrar por Año y Modo de envío (Shipping Mode),
recalculando en tiempo real los KPI’s de tiempos de entrega y los
gráficos comparativos por región y categoría. La sección de clientes
perdidos/retenidos (parte inferior) muestra el total histórico acumulado
y no responde a estos filtros, ya que representa un análisis
independiente de retención de clientes a lo largo de todo el período del
dataset (2015-2018).

## 8.0 Recomendaciones de negocio

1.  Dar un mayor seguimiento de los niveles de estado de entrega de los
    productos.

2.  Encontrar el paso crítico en el proceso final de la cadena de
    suministro, de esta manera pueden evitar que se salga aún más de
    control el proceso y llevarlo a un nivel estable.

3.  Aplicar metodologías para conocer la opinión del cliente en cuando a
    la satisfacción del producto y del servicio en general.

4.  Compensar a esos clientes con algún tipo de descuento en su próxima
    compra si su pedido llegó con demora.

## 9.0 Limitaciones y próximos pasos

**- Ausencia de datos de satisfacción del cliente:** el dataset no
incluye información de encuestas o calificaciones por lo que la relación
entre retrasos en la entrega y percepción del cliente sólo pudo
abordarse de forma indirecta, a través de la tasa de recompra tras una
cancelación.

**- Modo de envío sin analizar formalmente:** aunque la columna
“Shipping_Mode” fue incorporada al modelo de datos y puede explorarse de
forma interactiva en el dashboard, no se realizó un análisis formal en
SQL sobre su relación con la puntualidad de las entregas. Se identifica
como una pregunta de negocio relevante para una siguiente iteración del
proyecto.

**- Diferencia menor entre SQL y DAX:** el conteo de clientes con
cancelación dentro de la ventana de 6 meses arrojó 2,118 en SQL y 2,116
en DAX. Esta variación de 0.09% se atribuye a diferencias en el manejo
de casos límite de fecha/hora entre las funciones DATEADD (SQL) y EDATE
(DAX) pero esto no altera las conclusiones del análisis.

## 10.0 Estructura del repositorio

| **Archivo/Carpeta**                  | **Contenido**                                                     |
|--------------------------------------|-------------------------------------------------------------------|
| readme-proyecto-supplychain.md       | Documentación completa del proyecto                               | 
| sqlserver/queries_finales_supply_chain.sql | Las 5 preguntas de negocio con queries y hallazgos          |
| powerbi/dashboard_supply_chain.pbix  | Dashboard interactivo (Power BI Desktop)                          |
| images/dashboard_screenshot.png      | Capturas de queries, resultados y dashboard, usadas en este readme|
| data/dataset_link.md                 | Enlace a la fuente original del dataset en Kaggle                 |

## 👤 Autora

**Monica Chicas**

**LinkedIn:**

https://www.linkedin.com/in/monica-chicas-6132913bb/
