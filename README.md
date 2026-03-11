# Proyecto : Análisis de Retrasos en la Logística Empresarial (EE.UU.)

Este proyecto aplica modelos de regresión lineal multivariante (OLS) y análisis de datos avanzado para identificar las causas de los retrasos en una red logística de 7 ciudades de Estados Unidos (Detroit, Los Angeles, Nueva York, Miami, Houston, Portland y Kansas City). El análisis diferencia entre factores ambientales, operativos y estructurales para optimizar la toma de decisiones.

**Autora: Constanza Segovia Aspee**

---

## Índice

1. [Objetivo](#objetivo)
2. [Instalación](#instalacion)
3. [Contexto de negocio](#contexto-negocio)
4. [Estructura del proyecto](#estructura-proyecto)
5. [Dataset ](#dataset)
6. [Carpeta: API_clima](#api-clima)
7. [Carpeta: Notebook](#notebook)
8. [Carpeta: SQL](#sql)
9. [Carpeta: Power BI](#power-bi)
10. [Análisis de KPIs e hipótesis](#analisis-kpis)
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

- 66,146 registros operativos procesados.
- Datos climáticos históricos integrados vía API.

**Diccionario de datos**

Variables de las columnas:

`género`= género (Femenino/Masculino)



---

<a id="api_clima"></a>
## Carpeta: API_clima

Contiene los scripts de conexión, descarga de los data set de trabajo para el clima de estudio de las 7 ciudades y todos los datos meteorológicos disponibles. 


---
<a id="notebook"></a>
## Carpeta: Notebook

Incluye el proceso de
El análisis técnico se divide en:
- Limpieza de datos: Manejo de nulos y estandarización de unidades.
- EDA (Análisis Exploratorio): Visualización de distribuciones y correlaciones.
- Modelado OLS: Construcción del modelo de regresión para identificar significancia estadística (P-values).
- Validación: Verificación de supuestos de linealidad y normalidad.

---
<a id="sql"></a>
## Carpeta: SQL

Contiene los scripts SQL para la creación del esquema de base de datos y consultas complejas para unir la tabla de logística con los datos climáticos y los diferentes datasets de la empresa. Uniendo los siete en un solo archivo csv.

---
<a id="power-bi"></a>
## Carpeta: Power BI
Archivo .pbix con el dashboard interactivo que visualiza la tasa de incidentes, costos por clima y desempeño por ciudad.

---
<a id="analisis-kpis"></a>
## Análisis de KPIs e hipótesis

En la carpeta se encuentra el análisis de KPIs e hipótesis planteadas en el proyecto.

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
8. Finalizamos el proyecto con la carpeta  Notebooks abrimos el archivo `Dashboard.pbix` y ejecutamos el archivo o bien abrir la página web [Dashboard_Clima_Logistica](https:///).