/*Ejercicio 7
Club=(codigoClub, nombre, anioFundacion, codigoCiudad(fk))
Ciudad=(codigoCiudad, nombre)
Estadio=(codigoEstadio, codigoClub(fk), nombre, direccion)
Jugador=(DNI, nombre, apellido, edad, codigoCiudad(fk))
ClubJugador=(codigoClub(fk), DNI(fk), desde, hasta)*/

/*7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar de Plata*/

SELECT nombre 
FROM club
WHERE codigoClub NOT IN (
    SELECT cl.codigoClub
    FROM jugador j INNER JOIN clubJugador cl ON (j.DNI = cl.DNI) INNER JOIN ciudad ci ON (j.codigoCiudad = ci.codigoCiudad)
    WHERE (ci.nombre = "Mar del Plata")
)

/*8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la ciudad de cordoba*/

SELECT j.nombre, j.apellido
FROM jugador j INNER JOIN clubJugador cl ON (j.DNI = cl.DNI) INNER JOIN club c ON (cl.codigoClub = c.codigoClub) INNER JOIN ciudad ci ON (ci.codigoCiudad = c.codigoCiudad)
WHERE (ci.nombre = 'Cordoba')

/*9. Agregar el club "Estrella de Berisso", con codigo 1234, que se fundo en 1921 y que pertenece a la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla club*/

INSERT INTO club(codigoClub, nombre, anioFundacion, codigoCiudad) VALUES(1234, 'Estrella de Berisso', 1921, (SELECT codigoCiudad FROM ciudad WHERE nombre = 'Berisso'))