/*Ejercicio 8
Equipo=(codigoE, nombreE, descripcionE)
Integrante=(DNI, nombre, apellido, ciudad, email, telefono, codigoE(fk))
Laguna=(nroLaguna, nombreL, ubicacion, extension, descripcion)
TorneoPesca=(codTorneo, fecha, hora, nroLaguna, descripcion)
Inscripcion=(codTorneo(fk), codigoE(fk), asistio, gano)*/

/*1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad "La PLata" y esten inscriptos en torneos disputados en 2023*/

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM integrante int INNER JOIN equipo e ON (int.codigoE = e.codigoE) INNER JOIN inscripcion ins ON (e.codigoE = ins.codigoE) INNER JOIN torneoPesca tc ON (tc.codTorneo = ins.codTorneo)
WHERE (tc.fecha BETWEEN '01/01/2023' AND '31/12/2023') AND (i.ciudad = 'La Plata')

/*2. Reportar nombre y descripcion de equipos que solo se hayan inscripto en torneos de 2020*/

SELECT e.nombreE, e.descripcionE
FROM equipo e INNER JOIN inscripcion ins ON (e.codigoE = ins.codigoE) INNER JOIN torneoPesca tc ON (tc.codTorneo = ins.codTorneo)
WHERE (tc.fecha BETWEEN '01/01/2020' AND '31/12/2020')
EXCEPT(
    SELECT e.nombreE, e.descripcionE
    FROM equipo e INNER JOIN inscripcion ins ON (e.codigoE = ins.codigoE) INNER JOIN torneoPesca tc ON (tc.codTorneo = ins.codTorneo)
    WHERE (tc.fecha BETWEEN '01/01/2020' AND '31/12/2020')
)
