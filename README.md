# Proyecto : 
"Más allá del reloj: análisis multivariante de la logística empresarial estadounidense"

Este proyecto descompone la complejidad de los retrasos en la cadena de suministro mediante un modelo de regresión lineal multivariante (OLS). Al analizar siete nodos estratégicos, desde el dinamismo industrial de Detroit y Houston hasta los puntos de entrada clave en Nueva York, Miami y Los Ángeles, sin olvidar la conectividad de Portland y Kansas City, la investigación logra aislar el peso real de las variables ambientales, operativas y estructurales. El resultado es una herramienta diagnóstica que transforma datos crudos en decisiones tácticas para optimizar la puntualidad.

**Autora: Constanza Segovia Aspee**

---

## Índice

1. [Objetivo](#objetivo)
2. [Instalación](#instalacion)
3. [Contexto de negocio](#contexto-negocio)
4. [Dataset ](#dataset)
5. [Carpeta: API_clima](#api-clima)
6. [Carpeta: Notebook](#notebook)
7. [Carpeta: SQL](#sql)
8. [Carpeta: Power BI](#power-bi)
9. [Análisis de KPIs e hipótesis](#analisis-kpis)
11. [Resultados/Insights](#resultados-insights)
12. [Limitaciones y próximos pasos](#limitaciones-proximos-pasos)
13. [Cómo replicar el proyecto](#como-replicar)


---

<a id="objetivo"></a>
## Objetivo del proyecto

El objetivo del proyecto es determinar mediante evidencia estadística el impacto real que tienen las variables externas como el clima, como también las variables internas como el peso, distancia, detenciones, etc. en los minutos de retraso de la logística de la empresa. El fin es cuantificar el *porcentaje de influencia* de cada factor para priorizar inversiones operativas y reducir el tiempo de retraso.

---

<a id="instalacion"></a>
## Instalación

Necesario para ejecutar el proyecto:
- Lenguaje: `Python 3.13.9`
- Librerías principales: `pandas`, `statsmodels`, `matplotlib/seaborn` y `numpy`.
- Almacenamiento: `MySQL`
- Visualización: `Power BI` 

---
<a id="contexto-negocio"></a>
## Contexto de negocio

Se centra en las operaciones de carga y descarga en 7 ciudades (New York, Miami, Portland, Los Angeles, Houston, Detroit y Kansas City). 

El problema es que a pesar de tener rutas estandarizadas, los retrasos promedio superan los 70 minutos por evento y el 77% de los eventos presentan retrasos. Se planteá la hipótesis de que el clima y el tráfico son factores claves; este análisis busca confirmar o desmentir esta hipótesis mediante evidencia estadística. El objetivo es poder reducir de manera significativa los retrasos y mejorar la eficiencia operativa. 

---

<a id="dataset"></a>
## Dataset

**Fuentes de datos**

Detallaremos de donde sacamos los datos relevantes de nuestro análisis. 
- Primero: Dataset de operaciones logísticas de la empresa es tomado de Kaggle. Este entrega 14 data set de los cuales se seleccionan 7 para el análisis sobre como influyen los diferentes factores en los retrasos de los eventos de carga y descarga.
Cada data set tiene sus características propias:
   1. `eventos_entregas.csv`: se tienen 170 820 datos de los cuales nos quedamos con los eventos de carga y descarga de las 7 ciudades que hemos elegido por su ubicación geográfica y por su cantidad de habitantes, quedando con 66 416 eventos.
   2. `viajes.csv`: 
   3. `cargas.csv`:
   4. `clientes.csv`:
   5. `rutas.csv`:
   6. `compras_combustible.csv`:
   7. `incidentes_seguridad.csv`:

- Segundo: Datos climáticos históricos integrados vía API de la página [Visual Crossing](https://www.visualcrossing.com/) donde descargamos los datos desde 01-01-2022 hasta 02-01-2025 de las 7 ciudades seleccionadas, obteniendo datos de temperatura, humedad, precipitación, viento, etc. Como las descargas gratuitas tienen un límite de 1000 requests por día, se tuvo que descargar los datos en partes, quedando un total de 7 672 registros de clima en el dataset `Clima.csv`.

**Diccionario de datos**

Variables de las columnas del data set final de estudio, que se trabajo para las visualizaciones:

`id_evento` ID único del evento
`ciudad` Ciudad de origen
`tipo_evento` Tipo de evento (carga, descarga)
`fecha_hora_programada` Fecha y hora programada del evento
`fecha_hora_real` Fecha y hora real del evento
`retraso_minutos` Minutos de retraso del evento
`minutos_de_detencion` Minutos de detención del evento
`tem_max_C` Temperatura máxima del día en grados Celsius
`tem_min_C` Temperatura mínima del día en grados Celsius
`tem_C` Temperatura promedio del día en grados Celsius
`rocio_C` Punto de rocío del día en grados Celsius
`humedad_pct` Humedad relativa del día en porcentaje
`precip_mm` Precipitación del día en milímetros
`tipo_precip` Tipo de precipitación del día
`nieve_mm` Nieve del día en milímetros
`prof_nieve_mm` Profundidad de nieve del día en milímetros
`dir_viento_gr` Dirección del viento del día en grados
`nubosidad_pct` Nubosidad del día en porcentaje
`visibilidad_km` Visibilidad del día en kilómetros
`riesgo_severo` Riesgo severo del día
`condiciones` Condiciones del día
`ciudad_origen` Ciudad de origen
`ciudad_destino` Ciudad de destino
`distancia_tipica_millas` Distancia típica en millas
`distancia_km` Distancia en kilómetros
`tarifa_base_milla_eur` Tarifa base por milla en euros
`tasa_de_recargo_combustible` Tasa de recargo por combustible
`dias_de_transito_tipicos` Días típicos de tránsito
`nombre_cliente` Nombre del cliente
`tipo_cliente` Tipo de cliente
`tipo_carga_principal` Tipo de carga principal
`ingreso_eur` Ingreso en euros
`fecha_despacho` Fecha de despacho
`distancia_viaje` Distancia del viaje
`duracion_real_horas` Duración real en horas
`galones_combustible_usados` Galones de combustible usados
`mpg_promedio` MPG promedio
`horas_de_ralenti_RPM` Horas de ralentí en RPM
`fecha_carga` Fecha de carga
`tipo_carga` Tipo de carga
`peso_kg` Peso en kilogramos
`eur_carga` Carga en euros
`recargo_combustible` Recargo por combustible
`cargos_accesorios` Cargos por accesorios en euros
`tipo_reserva` Tipo de reserva
`a_tiempo` Si el despacho fue a tiempo si o no
`categoria_riesgo` Categoría de riesgo
`hora_dia` Hora del día en el que ocurrió el evento
`turno` Turno de noche (18:00 - 06:00) o de día (06:00 - 18:00)
`costo_logistico_total` Costo logístico total
`costo_por_km` Costo por kilómetro en euros
`hubo_incidente` Si hubo incidente si o no
`tipo_incidente` Tipo de incidente
`monto_reclamacion_eur` Monto de reclamación en euros
`causa` Causa del incidente
`clima_eficiencia` Eficiencia del clima
`ralenti_norm` Ralentí normalizado

---

<a id="api_clima"></a>
## Carpeta: API_clima

En esta carpeta te encontraras con: 
- `APIclima.ipynb`: Aqui se realiza la descarga de los datos climáticos históricos vía API de Visual Crossing, debes tener una cuenta en la página para obtener la key de la API.
- `Clima.csv`: Dataset final con todos los datos climáticos históricos descargados.
- `delivery_events.csv`: Dataset con los eventos de entrega y las ciudades seleccionadas para el análisis.
- `Funciones.py`: Funciones auxiliares para el análisis de datos, cambio de variables o limpieza de datos.
- `houston.csv`: Dataset con los datos climáticos de Houston.
- `union_clima.csv`: Dataset con la unión de los datos climáticos de algunas ciudades.
- `union_final.csv`: Dataset con la unión de los datos climáticos de ciudades faltantes.

---
<a id="notebook"></a>
## Carpeta: Notebook

En esta carpeta te encontraras con: 

- subcarpeta `ANALISIS`: aqui encontraras los siguientes archivos:

  - `analisis.ipynb`: Análisis de los datos en diversas dimensiones con los resultados obtenidos de SQL query.
  - `data_final.csv`: Dataset con los datos de logística resultado de los analisis realizados y otras nuevas categorías creadas.
  - `Funciones.py`: Funciones auxiliares para el análisis de datos climáticos, cambio de variables o limpieza de datos.
  - `incidentes.csv`: Dataset con los resultados de SQL query.
  - `UNION.csv`: Dataset con la unión de los datos de logística de SQL query.

- subcarpeta `HIPOTESIS_KPI`: aqui encontraras los siguientes archivos:

  - `data_final.csv`: Dataset con los datos de logística resultado de los analisis realizados y otras nuevas categorías creadas en los análisis.
  - `Funciones.py`: Funciones auxiliares para el análisis de datos, cambio de variables o limpieza de datos.
  - `df_final_analisis.csv`: Dataset con los datos de análisis de KPIs y de las hipótesis.
  - `diagrama.png`: Diagrama de flujo de los datos utilizados en SQL.
  - `Hipotesis_KPI.ipynb`: Análisis de las hipótesis, KPIs y modelos (OLS).
  - `incidentes.csv`: Dataset con los resultados de las SQL query.

- subcarpeta `LIMPIEZA`: aqui encontraras los siguientes archivos:

  - `Limpieza_union.ipynb`: Limpieza de los datos de la unión de los datos climáticos con los eventos y de todos los datasets para llevarlos limpios y traducidos a SQL.
  - `df_carga_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_clientes_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_combustible_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_incidente_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_rutas_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_union_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `df_viajes_estudio.csv`: Dataset con los datos limpios y listos para SQL.
  - `Funciones.py`: Funciones auxiliares para el análisis de datos, cambio de variables o limpieza de datos.
  - subcarpeta `data`: aqui encontraras los siguientes archivos:

    - `cargas.csv`: Dataset original en inglés sin limpiar.
    - `Clima.csv`: Dataset original en inglés sin limpiar.
    - `clientes.csv`: Dataset original en inglés sin limpiar.
    - `compras_combustible.csv`: Dataset original en inglés sin limpiar.
    - `incidentes_seguridad.csv`: Dataset original en inglés sin limpiar.
    - `rutas.csv`: Dataset original en inglés sin limpiar.
    - `eventos_entregas.csv`: Dataset original en inglés sin limpiar.
    - `viajes.csv`: Dataset original en inglés sin limpiar.

---
<a id="sql"></a>
## Carpeta: SQL

Contiene los scripts SQL para la creación del esquema de base de datos y consultas complejas para unir la tabla de logística con los datos climáticos y los diferentes datasets de la empresa. Uniendo los siete en un solo archivo csv.

---
<a id="power-bi"></a>
## Carpeta: Power BI

En esta carpeta encontraras: 
- `Dashboard_Logistica.pbix`: el dashboard interactivo que visualiza los incidentes, los costos por clima y el desempeño por ciudad. Es la presentación final del proyecto. Que se puede abrir directamente en Power BI en este link ["Más alla del reloj"](https://app.powerbi.com/groups/me/reports/0f356bfb-4040-43ca-a716-4d53d6f4dc8b/1c4bdc23041da9952e57?experience=power-bi)
- `df_final_analisis.csv`: el dataset final con los datos limpios y listos para el dashboard.

---
<a id="analisis-kpis"></a>
## Análisis de KPIs e hipótesis

En la carpeta de HIPOTESIS_KPI en el archivo `Hipotesis_KPI.ipynb` se encuentra el análisis detallado del estudio, se adjunta el detalle del  KPIs e hipótesis planteadas en el proyecto.

---
<a id="resultados-insights"></a>
## Resultados / Insights

**Resultado del estudio**

Los hallazgos más relevantes del proyecto son:

- El "Retraso Base" es Estructural: Se descubrió una constante estadística de ~72-79 minutos que ocurre independientemente de cualquier variable externa. El problema es el proceso inicial de despacho.
- El Peso no influye: Con un p-valor de 0.557, se descarta que el peso de la carga afecte los tiempos de entrega.
- Sensibilidad Térmica: El frío impacta más que el calor; las bajas temperaturas correlacionan con mayores demoras.
- Visibilidad: Es el factor meteorológico más crítico para la seguridad y el cumplimiento de horarios.



**Insights derivados directamente del estudio**

Resumen:

- Este proyecto demuestra que la ineficiencia logística en la red analizada no es una consecuencia inevitable del clima o de factores externos azarosos, sino un problema estructural de planificación.
Con un 77% de retrasos constantes y un retraso base de ~75 minutos identificado mediante el modelo OLS, la oportunidad de mejora no reside en "esperar mejores días", sino en rediseñar los procesos de despacho y optimizar el uso de combustible (ralentí). La evidencia estadística recolectada proporciona la hoja de ruta clara para transformar estas pérdidas operativas en ventajas competitivas.

---

<a id="limitaciones-proximos-pasos"></a>
## Limitaciones y próximos pasos

**Limitaciones**

- El dataset actual no desglosa el "tiempo de carga efectiva" del "tiempo de espera" o "trámites administrativos", lo que impide atacar con precisión el origen exacto del retraso base estructural identificado (~75 min).
- Falta información sobre datos de tráfico en tiempo real o accidentes de terceros en la ruta, lo que podría estar influyendo en las variables de ruido del modelo OLS.

**Próximos pasos**

- Teniendo en cuenta estos análisis del proyecto se espera que la empresa priorice las inversiones operativas que se realizan en la empresa, mejorando al 100% la puntualidad de los camiones. Creando un sistema de monitoreo continuo para mantener y mejorar los niveles de servicio. Además se sugieren estas acciones:

  - Logística: Aumentar los márgenes de tiempo en todas las rutas, especialmente en las Norte (durante el invierno) para evitar penalizaciones por retrasos validados.
  - Seguridad: Reforzar la conducción defensiva en días despejados, que es cuando ocurren los siniestros financieramente más críticos. Tal vez implementar un programa de capacitación especializada.
  - Eficiencia: Implementar un programa de reducción de ralentí, ya que las 7 horas actuales son constantes y representan un costo de combustible optimizable. Crear tal vez una alarma o notificación para los conductores que no excedan el tiempo de ralentí.

---

<a id="como-replicar"></a>
## Cómo replicar el proyecto

Orden recomendado:

1. Clonar el repositorio en tu computadora.
2. Abrir primero la carpeta API_clima y ejecutar el jupyter notebook `APIclima.ipynb` para descargar los datos climáticos de las 7 ciudades.
3. Si no deseas descargar los archivos, puedes usar los archivos ya descargados en la carpeta `API_clima`.
4. Segundo, abrir la carpeta Notebooks y luego la subcarpeta LIMPIEZA el archivo `Limpieza_union.ipynb` y ejecutarlo desde el inicio ahí uniremos los datasets de clima y eventos para hacer la limpieza y dejar 7 datasets limpios para exportar en SQL.
5. Tercero, abrir la carpeta SQL y ejecutar el archivo `estudio.sql` para crear las tablas en la base de datos de `incidentes.csv` y `UNION.csv`.
6. Con esos archivos SQL, abrir la carpeta Notebooks en la subcarpeta ANALISIS el archivo `analisis.ipynb` y ejecutarlo desde el inicio ahí realizaremos el análisis de los datos y generaremos los insights para poder hacer el estudio de Hipótesis.
7. Siguiente, abrir la carpeta Notebooks en la subcarpeta HIPOTESIS_KPI el archivo `Hipotesis_KPI.ipynb` y ejecutarlo desde el inicio ahí realizaremos el análisis de las hipótesis y llegamos a las conclusiones del proyecto.
8. Finalizamos el proyecto con la carpeta  Notebooks abrimos el archivo `Dashboard_Logistica.pbix` y ejecutamos el archivo o bien abrir la página web ["Más alla del reloj"](https://app.powerbi.com/groups/me/reports/0f356bfb-4040-43ca-a716-4d53d6f4dc8b/1c4bdc23041da9952e57?experience=power-bi).