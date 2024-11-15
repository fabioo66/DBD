/*Ejercicio 10
Vehiculo = (patente, modelo, marca, peso, km)
Camion = (patente(fk), largo, max_toneladas, cant_ruedas, tiene_acoplado)
Auto = (patente(fk), es_electrico, tipo_motor)
Service = (fecha, patente(fk), km_service, descripcion, monto)
Parte = (cod_parte, nombre, precio_parte)
Service_Parte = ([fecha, patente](fk), cod_parte(fk), precio)*/

/*1. Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan
realizado algún service en los últimos 365 días. Ordenar por marca, modelo y patente.*/

SELECT v.patente, v.modelo, v.marca, v.peso, v.km, c.largo, c.max_toneladas, c.cant_ruedas, c.tiene_acoplado
FROM vehiculo v INNER JOIN camion c ON (v.patente = c.patente) INNER JOIN service s ON (v.patente = s.patente)
WHERE (c.cant_ruedas >= 4 AND c.cant_ruedas <= 8) AND (s.fecha >= '11/11/2023')
ORDER BY v.marca, v.modelo, v.patente

/*2. Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o
hayan realizado el service “inspección general” que incluya la parte “filtro de combustible”.*/

SELECT a.patente 
FROM auto a INNER JOIN service s ON (a.patente = s.patente) 
WHERE (s.descripcion = 'cambio de aceite' AND s.km_service < 13000) 
UNION 
SELECT a.patente
FROM auto a INNER JOIN service s ON (a.patente = s.patente) INNER JOIN service_parte sp ON (s.fecha = sp.fecha AND s.patente = sp.patente) INNER JOIN parte p ON (sp.cod_parte = p.cod_parte)
WHERE (s.descripcion = 'inspección general' AND p.nombre = 'filtro de combustible')

/*3. Listar nombre y precio de todas las partes que aparezcan en más de 30 services que hayan
salido (partes) más de $4.000.*/

SELECT p.nombre, p.precio_parte
FROM parte p INNER JOIN service_parte sp ON (p.cod_parte = sp.cod_parte)
WHERE (sp.precio > 4000)
GROUP BY p.cod_parte, p.nombre, p.precio_parte
HAVING COUNT(*) > 30

/*4. Dar de baja todos los camiones con más de 250.000 km.*/

DELETE FROM service_parte WHERE patente IN (
    SELECT v.patente
    FROM camion c INNER JOIN vehiculo v ON (c.patente = v.patente)
    WHERE (v.km > 250000)
)

DELETE FROM service WHERE patente IN (
    SELECT v.patente
    FROM camion c INNER JOIN vehiculo v ON (c.patente = v.patente)
    WHERE (v.km > 250000)
)

DELETE FROM camion WHERE patente IN (
    SELECT v.patente
    FROM camion c INNER JOIN vehiculo v ON (c.patente = v.patente)
    WHERE (v.km > 250000)
)

/*5. Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el año
actual.*/

SELECT p.nombre, p.precio_parte
FROM parte p 
WHERE NOT EXISTS (
    SELECT * 
    FROM service_parte
    WHERE NOT EXISTS (
        SELECT * 
        FROM service s
        WHERE (s.fecha BETWEEN '01/01/2024' AND '31/12/2024') AND (s.patente = service_parte.patente AND s.fecha = service_parte.fecha)
    )
)

/*6. Listar todos los autos que sean eléctricos. Mostrar información de patente, modelo, marca y
peso.*/ 

SELECT v.patente, v.modelo, v.marca, v.peso, v.km, a.tipo_motor
FROM vehiculo v INNER JOIN auto a ON (v.patente = a.patente)
WHERE (a.es_electrico = true)

/*7. Dar de alta una parte, cuyo nombre sea “Aleron” y precio $5000.*/

INSERT INTO parte (cod_parte, nombre, precio_parte) VALUES (8, 'Aleron', 5000)

/*8. Dar de baja todos los services que se realizaron al auto con patente ‘AWA564’.*/ 

DELETE FROM service_parte WHERE patente = 'AWA564'
DELETE FROM service WHERE patente = 'AWA564'

/*9. Listar todos los vehículos que hayan tenido services durante el 2024.*/ 

SELECT v.patente, v.modelo, v.marca, v.peso, v.km
FROM vehiculo v INNER JOIN service s ON (v.patente = s.patente)
WHERE (s.fecha BETWEEN '01/01/2024' AND '31/12/2024')

/*Vehiculo = (patente, modelo, marca, peso, km)
Camion = (patente(fk), largo, max_toneladas, cant_ruedas, tiene_acoplado)
Auto = (patente(fk), es_electrico, tipo_motor)
Service = (fecha, patente(fk), km_service, descripcion, monto)
Parte = (cod_parte, nombre, precio_parte)
Service_Parte = ([fecha, patente](fk), cod_parte(fk), precio)*/