/*Ejercicio 6
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.*/

/*1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.*/

SELECT nombre, stock, precio
FROM repuesto
ORDER BY precio;

/*2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
se usaron en reparaciones del técnico ‘José Gonzalez’.*/

SELECT r.nombre, r.stock, r.precio
FROM repuesto r INNER JOIN repuestoReparacion rr ON (r.codRep = rr.codRep) INNER JOIN reparacion re ON (rr.nroReparac = re.nroReparac)
WHERE (re.fecha BETWEEN '01/01/2023' AND '31/12/2023')
EXCEPT(
    SELECT r.nombre, r.stock, r.precio
    FROM repuesto r INNER JOIN repuestoReparacion rr ON (r.codRep = rr.codRep) INNER JOIN reparacion re ON (rr.nroReparac = re.nroReparac) INNER JOIN tecnico t ON (re.codTec = t.codTec)
    WHERE (re.codTec = 'José Gonzalez')
)

/*3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
por nombre ascendentemente.*/

SELECT nombre, especialidad
FROM tecnico 
WHERE codTec NOT IN (
    SELECT codTec
    FROM reparacion
)
ORDER BY nombre;

/*4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
durante 2022.*/

SELECT nombre, especialidad
FROM tecnico INNER JOIN reparacion ON (tecnico.codTec = reparacion.codTec)
WHERE (reparacion.fecha BETWEEN '01/01/2022' AND '31/12/2022')
EXCEPT(
    SELECT nombre, especialidad
    FROM tecnico INNER JOIN reparacion ON (tecnico.codTec = reparacion.codTec)
    WHERE (fecha NOT BETWEEN '01/01/2022' AND '31/12/2022')
)

/*5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
repuesto no participó en alguna reparación igual debe aparecer en dicho listado.*/

SELECT r.nombre, r.stock, COUNT(DISTINCT codTec) as cantidad
FROM repuesto r LEFT JOIN repuestoReparacion rr ON (r.codRep = rr.codRep)
GROUP BY r.codRep, nombre, stock;

/*6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
técnico con menor cantidad de reparaciones.*/

SELECT t.nombre, t.especialidad
FROM tecnico t INNER JOIN reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM tecnico t INNER JOIN reparacion r ON (t.codTec = r.codTec)
    GROUP BY t.codTec
)
UNION
SELECT t.nombre, t.especialidad
FROM tecnico t INNER JOIN reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) <= ALL(
    SELECT COUNT(*)
    FROM tecnico t INNER JOIN reparacion r ON (t.codTec = r.codTec)
    GROUP BY t.codTec
)

/*7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
no haya estado en reparaciones con un precio total superior a $10000.*/

SELECT nombre, stock, precio
FROM repuesto  
WHERE (stock > 0) AND (codRep NOT IN (
    SELECT codRep
    FROM reparacion  
    WHERE precio_total > 10000
)

/*8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
con precio en el momento de la reparación mayor a $10000 y menor a $15000.*/

SELECT r.nroReparac, r.fecha, r.precio_total
FROM reparacion r INNER JOIN repuestoReparacion rr ON (r.nroReparac = rr.nroReparac) 
WHERE (rr.precio > 10000) AND (rr.precio < 15000)

/*9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.*/

SELECT nombre, stock, precio
FROM repuesto r
WHERE NOT EXISTS(
    SELECT *
    FROM tecnico t
    WHERE NOT EXISTS(
        SELECT *
        FROM repuestoReparacion rr INNER JOIN reparacion r ON (rr.nroReparac = re.nroReparac)
        WHERE (r.codRep = rr.codRep) AND (t.codTec = rr.codTec)
    )
)

/*10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10
repuestos distintos¨*/

SELECT r.fecha, t.nombre, r.precio_total
FROM reparacion r INNER JOIN tecnico t ON (r.codTec = t.codTec) INNER JOIN repuestoReparacion rr ON (r.nroReparac = rr.nroReparac)
GROUP BY r.nroReparac, r.fecha, t.nombre, r.precio_total
HAVING COUNT(*) >= 10