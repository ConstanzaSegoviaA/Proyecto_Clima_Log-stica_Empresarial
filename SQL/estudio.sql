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



