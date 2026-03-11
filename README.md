# Proyecto : Retrasos en la logística empresarial.

Este proyecto aplica modelos de regresión estadística (OLS) y análisis de datos avanzado para identificar las causas de los retrasos en una red logística de 7 ciudades de Estados Unidos que son Detroit, Los Angeles, Nueva York, Miami, Houston, Portland y Kansas City. El análisis diferencia entre factores ambientales, operativos y estructurales.

**Constanza Segovia Aspee**

---

## Índice

1. [Objetivo](#objetivo)
2. [Instalación](#instalacion)
3. [Contexto de negocio](#contexto-negocio)
4. [Estructura del proyecto](#estructura-proyecto)
5. [Dataset ](#dataset)
6. [Notebook : "Proyecto_Clima_Logistica"](#Notebook)
7. [Resultados](#resultados)
8. [Limitaciones y próximos pasos](#limitaciones-proximos-pasos)
9. [Cómo replicar el proyecto](#como-replicar)


---

<a id="objetivo"></a>
## Objetivo del proyecto

El objetivo del proyecto es determinar científicamente si las variables como el clima, peso, distancia, detenciones, etc. tienen un impacto real en los minutos de retraso de las entregas/descargas. La idea es tener una mejora en el tiempo de retraso. Será clave contar con el porcentaje de influencia de cada factor para luego asi poder priorizar las inversiones operativas que se realizan en la empresa.

---

<a id="instalacion"></a>
## Instalación

Requisitos:
- `Python 3.13.9`
- `MySQL`
- `Power BI` 


---
<a id="contexto-negocio"></a>
## Contexto de negocio

Se centra el estudio en las operaciones de la empresa en 7 ciudades clave (New York, Miami, Portland, Los Angeles, Houston, Detroit y Kansas City). A pesar de tener rutas estandarizadas, los retrasos promedio superan los 70 minutos por evento y el 77% de los eventos presentan retrasos. Se sospechaba del clima y el tráfico; este análisis busca confirmar o desmentir dichas suposiciones mediante evidencia estadística. Demás poder reducir de manera significativa los retrasos y mejorar la eficiencia operativa. Teniendo en cuenta estos análisis del proyecto poder priorizar las inversiones operativas que se realizan en la empresa

---

<a id="dataset"></a>
## Dataset

**Fuentes de datos**

- I.

**Diccionario de datos**

Variables de las columnas:

`género`= género (Femenino/Masculino)



---

<a id="Notebook"></a>
## Notebook




---

<a id="resultados-insights"></a>
## Resultados / Insights

**Resultado del estudio**

Los hallazgos más relevantes del proyecto son:
El "Retraso Base" es Estructural: Se descubrió una constante estadística de ~72-79 minutos que ocurre independientemente de cualquier variable externa. El problema es el proceso inicial de despacho.
El Peso no es un Factor: Con un p-valor de 0.557, se demostró que cargar más peso no incrementa los retrasos en muelle.
Sensibilidad Térmica: Existe una relación inversa significativa. Las temperaturas bajas castigan más la puntualidad que el calor.
Visibilidad Crítica: Es el único factor meteorológico con impacto real en la seguridad y tiempo de tránsito.


**Insights derivados directamente del estudio**

- 

![alt text](imagen/image.png)

---

<a id="limitaciones-proximos-pasos"></a>
## Limitaciones y próximos pasos

**Limitaciones**

- El dataset no desglosa el "tiempo de carga" del "tiempo de espera en muelle", lo que oculta parte del retraso base.
**Próximos pasos**

- 
---

<a id="como-replicar"></a>
## Cómo replicar el proyecto

Orden recomendado:

1. Clonar el repositorio en tu computadora.
2. Abrir primero la carpeta Notebooks `.ipynb`.Comenzar desde el inicio del notebook.
3. .

Notas de reproducibilidad:
- El notebook `Proyecto_Obesidad.ipynb` genera el dataset `ObesityDataSet_clean.csv` que es el utilizado para el modelo. 
- También genera los archivos `mi_escalador_entrenado.pkl` para escalar los datos nuevos, `columnas_modelo.pkl` que es el resultado entrenado y `prediccion_obesidad.pkl` que es el modelo utilizado para la predicción y usar en streamlit.
- Se tienen dos archivos .py que son `Funciones.py` y `modelos.py` utilizados en el notebook `Proyecto_Obesidad.ipynb`, como en el streamlit `app.py` o bien a la página web [Streamlit_obesidad](https://proyecto-estudio-obesidad.streamlit.app/).