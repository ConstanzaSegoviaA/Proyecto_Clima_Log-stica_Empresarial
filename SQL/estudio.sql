use logistica;

-- todos los datos juntos
CREATE VIEW vista_datos AS
SELECT
e.id_evento,
e.ciudad,
e.tipo_evento,
e.fecha_hora_programada,
e.fecha_hora_real,
e.minutos_de_detencion,
e.tem_max_C,
e.tem_min_C, 
e.tem_C,
e.rocio_C,
e.humedad_pct,
e.precip_mm,
e.tipo_precip,
e.nieve_mm,
e.prof_nieve_mm,
e.dir_viento_gr,
e.nubosidad_pct,
e.visibilidad_km, 
e.riesgo_severo,
e.condiciones,
r.ciudad_origen,
r.ciudad_destino,
r.distancia_tipica_millas,
r.distancia_km,
r.tarifa_base_milla_eur,
r.tasa_de_recargo_combustible,
r.dias_de_transito_tipicos,
cl.nombre_cliente,
cl.tipo_cliente,
cl.tipo_carga_principal,
cl.ingreso_eur,
v.fecha_despacho,
v.distancia_km AS distancia_viaje,
v.duracion_real_horas,
v.galones_combustible_usados,
v.mpg_promedio,
v.horas_de_ralenti_RPM,
c.fecha_carga,
c.tipo_carga,
c.peso_kg,
c.ingreso_eur AS eur_carga,
c.recargo_combustible,
c.cargos_accesorios,
c.tipo_reserva
FROM eventos_entrega_clima AS e
JOIN cargas AS c
ON e.id_carga=c.id_carga
JOIN cliente AS cl
ON c.id_cliente = cl.id_cliente
JOIN rutas AS r
ON c.id_ruta = r.id_ruta
JOIN viajes AS v
ON e.id_viaje=v.id_viaje;

-- los incidentes totales y bencinas juntos
CREATE VIEW vista_incidentes AS
SELECT
e.id_evento,
e.ciudad,
e.estado,
e.tipo_evento,
e.fecha_hora_programada,
e.fecha_hora_real,
e.minutos_de_detencion,
e.tem_max_C,
e.tem_min_C, 
e.tem_C,
e.rocio_C,
e.humedad_pct,
e.precip_mm,
e.prob_precip_pct,
e.cob_precip_pct,
e.tipo_precip,
e.nieve_mm,
e.prof_nieve_mm,
e.dir_viento_gr,
e.nubosidad_pct,
e.visibilidad_km, 
e.riesgo_severo,
e.condiciones,
r.ciudad_origen,
r.ciudad_destino,
r.distancia_tipica_millas,
r.distancia_km,
r.tarifa_base_milla_eur,
r.tasa_de_recargo_combustible,
r.dias_de_transito_tipicos,
cl.nombre_cliente,
cl.tipo_cliente,
cl.tipo_carga_principal,
cl.ingreso_eur,
v.fecha_despacho,
v.distancia_real_millas,
v.distancia_km AS distancia_viaje,
v.duracion_real_horas,
v.galones_combustible_usados,
v.mpg_promedio,
v.horas_de_ralenti_RPM,
c.fecha_carga,
c.tipo_carga,
c.peso_lbs,
c.peso_kg,
c.ingreso_eur AS eur_carga,
c.recargo_combustible,
c.cargos_accesorios,
c.estado_carga,
c.tipo_reserva,
b.fecha_compra,
b.ciudad AS ciudad_ben, 
b.galones,
b.precio_por_galon,
b.costo_total_eur,
i.fecha_incidente,
i.tipo_incidente,
i.ciudad AS ciudad_incidente,
i.indicador_de_falla,
i.indicador_de_lesion,
i.monto_reclamacion_eur,
i.indicador_prevenible,
i.nivel,
i.causa
FROM eventos_entrega_clima AS e
JOIN cargas AS c
ON e.id_carga=c.id_carga
JOIN cliente AS cl
ON c.id_cliente = cl.id_cliente
JOIN rutas AS r
ON c.id_ruta = r.id_ruta
JOIN viajes AS v
ON e.id_viaje=v.id_viaje
JOIN incidentes AS i
ON v.id_viaje = i.id_viaje
LEFT JOIN compra_combustible AS b
ON v.id_viaje = b.id_viaje;

-- solo los viajes con incidentes
CREATE VIEW numero_incidentes AS
Select
e.ciudad,
e.tipo_evento,
e.tem_C,
e.condiciones,
i.causa,
i.nivel,
i.monto_reclamacion_eur,
i.ciudad AS ciudad_in
FROM eventos_entrega_clima AS e
JOIN incidentes AS i
ON e.id_viaje=i.id_viaje;

-- por region media de minutos detenido
WITH vista_analisis_total AS (
    SELECT 
	ciudad,
    minutos_de_detencion,
    -- Variable de región
        CASE WHEN ciudad IN ('Detroit', 'New York') THEN 'Norte'
             WHEN ciudad IN ('Miami', 'Houston') THEN 'Sur'
             ELSE 'Otras' END AS region,
        -- Variable de precipitación > 10mm (Lluvia o Nieve)
        CASE WHEN (precip_mm > 10 OR nieve_mm > 10) THEN 1 ELSE 0 END AS clima_severo
    FROM vista_analisis_total
    WHERE ciudad IN ('Detroit', 'New York', 'Miami', 'Houston')
)
SELECT 
region, 
clima_severo, 
AVG(minutos_de_detencion) as media_minutos,
COUNT(*) as total_eventos
FROM vista_analisis_total
GROUP BY 1, 2;

-- minutos de retraso
SELECT 
id_evento,
fecha_hora_programada, 
fecha_hora_real,
TIMESTAMPDIFF(MINUTE, fecha_hora_programada, fecha_hora_real) AS minutos_retraso
FROM vista_accidentes;

-- Veamos la compra de combustible
select 
e.id_evento,
e.tipo_evento,
e.ciudad,
e.condiciones,
e.fecha_hora_programada,
e.fecha_hora_real,
b.fecha_compra,
b.ciudad AS ciudad_ben,
b.costo_total_eur AS valor,
v.fecha_despacho,
v.distancia_km
From eventos_entrega_clima AS e
JOIN compra_combustible AS b
ON e.id_viaje = b.id_viaje
JOIN viajes AS v
ON b.id_viaje= v.id_viaje;

-- eventos con sus rutas y viajes
select 
e.id_evento,
e.tipo_evento,
e.condiciones,
e.fecha_hora_programada,
e.fecha_hora_real,
v.duracion_real_horas,
v.fecha_despacho,
c.fecha_carga,
v.distancia_km,
c.tipo_carga,
e.ciudad,
r.ciudad_origen,
r.ciudad_destino,
r.dias_de_transito_tipicos
From eventos_entrega_clima AS e
JOIN viajes AS v
ON e.id_viaje= v.id_viaje
JOIN cargas AS c
ON v.id_carga=c.id_carga
JOIN rutas AS r
ON c.id_ruta= r.id_ruta;

-- porcentaje de incidentes versus el total

SELECT 
    (SELECT COUNT(*) 
    FROM vista_incidentes) * 100.0 / 
    (SELECT COUNT(*)
    FROM vista_totales) AS porcentaje_incidentes;

-- Viajes con recargas de bencina

Select
e.id_viaje,
e.id_evento,
b.costo_total_eur,
b.fecha_compra
FROM eventos_entrega_clima AS e
JOIN compra_combustible AS b
ON e.id_viaje= b.id_viaje;

-- KPI Tiempo promedio: comparamos fecha programada vs fecha real
SELECT 
    AVG(TIMESTAMPDIFF(MINUTE, fecha_hora_programada, fecha_hora_real)) AS promedio_desfase_minutos,
    MIN(TIMESTAMPDIFF(MINUTE, fecha_hora_programada, fecha_hora_real)) AS adelanto_maximo,
    MAX(TIMESTAMPDIFF(MINUTE, fecha_hora_programada, fecha_hora_real)) AS retraso_maximo
FROM eventos_entrega_clima;

-- kpi Tiempo de retraso: Promedio de la diferencia entre el retraso y las condiciones climáticas
SELECT 
condiciones AS condicion_climatica,
AVG(TIMESTAMPDIFF(MINUTE, fecha_hora_programada, fecha_hora_real)) AS retraso_promedio_min,
AVG(precip_mm) AS precipitacion_promedio_mm,
AVG(vel_viento_km_h) AS velocidad_viento_promedio,
AVG(visibilidad_km) AS visibilidad_promedio_km,
COUNT(*) AS total_eventos
FROM eventos_entrega_clima
WHERE fecha_hora_real IS NOT NULL 
  AND fecha_hora_programada IS NOT NULL
GROUP BY condiciones
ORDER BY retraso_promedio_min DESC;

-- kpi Relación impacto clima vs costo: Comparamos el impacto del clima versus el costo logístico asociado.
SELECT 
e.condiciones AS condicion_climatica,
AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
AVG(c.ingreso_dolar + c.recargo_combustible + c.cargos_accesorios) AS costo_logistico_total_promedio,
COUNT(e.id_evento) AS cantidad_eventos
FROM eventos_entrega_clima AS e
JOIN cargas AS c 
ON e.id_carga = c.id_carga
JOIN viajes AS v 
ON e.id_viaje = v.id_viaje
GROUP BY e.condiciones
ORDER BY costo_logistico_total_promedio DESC;

-- kpi Frecuencia de incidentes según el tipo de precipitación: de los incidentes identificados, se analiza la frecuencia según el tipo de precipitación y se determina la causa.
SELECT 
e.tipo_precip,
i.causa,
COUNT(i.id_incidente) AS cantidad_incidentes,
ROUND(AVG(i.monto_reclamacion_dolar), 2) AS costo_medio_reclamacion
FROM incidentes AS i
JOIN eventos_entrega_clima AS e 
ON i.id_viaje = e.id_viaje
WHERE e.tipo_precip IS NOT NULL 
GROUP BY e.tipo_precip, i.causa 
ORDER BY cantidad_incidentes DESC, e.tipo_precip;

-- hipotesis "Las condiciones climáticas afectan el tiempo de detención en las ciudades del norte comparado con el Sur"
SELECT 
    CASE 
        WHEN e.ciudad IN ('New York', 'Detroit') THEN 'Norte'
        WHEN e.ciudad IN ('Miami', 'Houston') THEN 'Sur'
        ELSE 'Otras Regiones'
    END AS region,
    AVG(e.minutos_de_detencion) AS promedio_detencion_min,
    COUNT(*) AS total_eventos,
    AVG(e.tem_C) AS temperatura_promedio,
    AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min
FROM eventos_entrega_clima e
WHERE e.minutos_de_detencion > 0
GROUP BY region
HAVING region <> 'Otras Regiones'
ORDER BY region, promedio_detencion_min DESC;

-- hipotesis, "El tipo de carga principal influye en el coste logístico y en el tiempo de retraso"
SELECT 
cl.tipo_carga_principal,
AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
AVG(ca.ingreso_dolar) AS tarifa_base_promedio,
AVG(ca.recargo_combustible + ca.cargos_accesorios) AS costos_adicionales_promedio,
AVG((ca.ingreso_dolar + ca.recargo_combustible) / v.distancia_real_millas) AS costo_por_milla_real,
COUNT(ca.id_carga) AS numero_operaciones
FROM cliente AS cl
JOIN cargas AS ca 
ON cl.id_cliente = ca.id_cliente
JOIN eventos_entrega_clima AS e 
ON ca.id_carga = e.id_carga
JOIN viajes v ON ca.id_carga = v.id_carga
GROUP BY cl.tipo_carga_principal
ORDER BY retraso_promedio_min DESC;

-- hipotesis "Las temperaturas extremas incrementan significativamente las horas de ralentí"
SELECT 
    CASE 
        WHEN e.tem_C < 0 THEN 'Frío Extremo (<0°C)'
        WHEN e.tem_C BETWEEN 0 AND 25 THEN 'Templado (0°C - 25°C)'
        WHEN e.tem_C > 25 THEN 'Calor Extremo (>25°C)'
    END AS categoria_temperatura,
AVG(v.horas_de_ralenti_RPM) AS promedio_horas_ralenti,
    AVG(v.galones_combustible_usados) AS consumo_combustible_medio,
    -- Calculamos el porcentaje de ralentí sobre la duración total del viaje
    AVG(v.horas_de_ralenti_RPM / v.duracion_real_horas) * 100 AS pct_tiempo_ralenti,
    COUNT(e.id_evento) AS numero_eventos
FROM viajes AS v
JOIN eventos_entrega_clima AS e 
ON v.id_viaje = e.id_viaje
GROUP BY categoria_temperatura
ORDER BY promedio_horas_ralenti DESC;

-- hipótesis "Las condiciones climaticas como lluvia, visibilidad,temperatura y humedad aumentan los retrasos"
SELECT 
CASE 
	WHEN e.visibilidad_km < 2 THEN 'Baja (0-2km)'
    WHEN e.visibilidad_km BETWEEN 2 AND 8 THEN 'Moderada (2-8km)'
    ELSE 'Alta (>8km)'
    END AS rango_visibilidad,
    AVG(e.humedad_pct) AS humedad_media,
    AVG(e.tem_C) AS temperatura_media,
    AVG(e.precip_mm) AS precipitacion_media,
	AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
    COUNT(e.id_evento) AS cantidad_eventos
FROM eventos_entrega_clima AS e
GROUP BY rango_visibilidad
HAVING retraso_promedio_min > 0
ORDER BY retraso_promedio_min DESC;

-- hipótesis "Las cargas pesadas generan más detenciones y retrasos"
SELECT 
CASE 
  WHEN c.peso_kg < 5000 THEN 'Ligera (<5t)'
  WHEN c.peso_kg BETWEEN 5000 AND 15000 THEN 'Media (5t-15t)'
   ELSE 'Pesada (>15t)'
    END AS categoria_peso,
AVG(e.minutos_de_detencion) AS promedio_minutos_detencion,
AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
AVG(v.mpg_promedio) AS eficiencia_combustible_mpg,
COUNT(e.id_evento) AS cantidad_eventos
FROM cargas AS c
JOIN eventos_entrega_clima AS e 
ON c.id_carga = e.id_carga
JOIN viajes AS v 
ON c.id_carga = v.id_carga
GROUP BY categoria_peso
ORDER BY promedio_minutos_detencion DESC;

-- Hipótesis "Distancias mayores estan asociadas a mayores retrasos"
SELECT 
CASE 
  WHEN v.distancia_real_millas < 200 THEN 'Corta Distancia (<200 mi)'
  WHEN v.distancia_real_millas BETWEEN 200 AND 600 THEN 'Media Distancia (200-600 mi)'
   ELSE 'Larga Distancia (>600 mi)'
END AS categoria_distancia,
AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
AVG(v.duracion_real_horas) AS horas_en_ruta_promedio,
COUNT(i.id_incidente) * 1.0 / NULLIF(COUNT(e.id_evento), 0) AS tasa_incidentes,
COUNT(e.id_evento) AS cantidad_eventos
FROM viajes as v
JOIN eventos_entrega_clima as e 
ON v.id_viaje = e.id_viaje
LEFT JOIN incidentes as i
ON v.id_viaje = i.id_viaje
GROUP BY 1 
ORDER BY AVG(v.distancia_real_millas) ASC; 

-- Hipótesis "Más detenciones causan retrasos significativos"
SELECT 
    CASE 
        WHEN e.minutos_de_detencion = 0 THEN 'Sin detenciones'
        WHEN e.minutos_de_detencion BETWEEN 1 AND 30 THEN 'Detención breve (1-30 min)'
        WHEN e.minutos_de_detencion BETWEEN 31 AND 120 THEN 'Detención moderada (31-120 min)'
        ELSE 'Detención crítica (>2h)'
    END AS nivel_detencion,
  AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
  AVG(e.precip_mm) AS precipitacion_media_mm,
  AVG(e.visibilidad_km) AS visibilidad_media_km,
  COUNT(e.id_evento) AS total_eventos
FROM eventos_entrega_clima AS e
GROUP BY 1 
ORDER BY AVG(e.minutos_de_detencion) ASC;

-- Hipótesis  "La temperartura tiene un impacto negativo en los retrasos"
SELECT 
CASE 
  WHEN e.tem_C < 0 THEN 'Frío Extremo (<0°C)'
  WHEN e.tem_C BETWEEN 0 AND 15 THEN 'Frío Moderado (0-15°C)'
  WHEN e.tem_C BETWEEN 16 AND 28 THEN 'Ideal (16-28°C)'
  WHEN e.tem_C BETWEEN 29 AND 38 THEN 'Calor Moderado (29-38°C)'
  ELSE 'Calor Extremo (>38°C)'
    END AS rango_temperatura,
AVG(TIMESTAMPDIFF(MINUTE, e.fecha_hora_programada, e.fecha_hora_real)) AS retraso_promedio_min,
AVG(v.mpg_promedio) AS eficiencia_combustible_mpg,
AVG(v.horas_de_ralenti_RPM) AS promedio_ralenti_horas,
COUNT(e.id_evento) AS cantidad_eventos
FROM eventos_entrega_clima As e
JOIN viajes AS v
ON e.id_viaje = v.id_viaje
GROUP BY 1
ORDER BY AVG(e.tem_C) ASC;







