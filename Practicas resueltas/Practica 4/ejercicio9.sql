/*Ejercicio 9
Proyecto = (codProyecto, nombrP,descripcion, fechaInicioP, fechaFinP, fechaFinEstimada,
DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK)) // DNIResponsable corresponde a un
empleado, equipoBackend y equipoFrontend corresponden a equipos
Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK))//DNILider corresponde a un empleado
Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
Empleado_Equipo = (codEquipo(FK, DNI(FK), fechaInicio, fechaFin, descripcionRol)*/

/*1. Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no
fueron terminados antes de la fecha de fin estimada.*/

SELECT nombreP, descripcion, fechaInicioP, fechaFinP
FROM proyecto 
WHERE (fechaFinP > fechaFinEstimada)

/*2. Listar DNI, nombre, apellido, teléfono, dirección y fecha de ingreso de empleados que no son, ni
fueron responsables de proyectos. Ordenar por apellido y nombre.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM empleado e 
WHERE e.DNI NOT IN (
    SELECT DNIResponsable
    FROM proyecto
)

/*3. Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un
equipo a cargo.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM empleado e INNER JOIN equipo eq ON (e.DNI = eq.DNILider)
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
HAVING COUNT(*) > 1

/*4. Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el
proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes de equipo.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM empleado e INNER JOIN empleado_equipo ee ON (e.DNI = ee.DNI) INNER JOIN proyecto p ON (ee.codEquipo = p.equipoBackEnd)
WHERE (p.nombreP = 'Proyecto X')
UNION
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM empleado e INNER JOIN empleado_equipo ee ON (e.DNI = ee.DNI) INNER JOIN proyecto p ON (ee.codEquipo = p.equipoFrontEnd)
WHERE (p.nombreP = 'Proyecto X')

/*5. Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados
asignados y trabajen con tecnología ‘Java’.*/

SELECT eq.nombreE, e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM equipo eq INNER JOIN empleado e ON (eq.DNILider = e.DNI)
WHERE (eq.descTecnologias = 'Java') AND eq.codEquipo NOT IN (
    SELECT codEquipo
    FROM empleado_equipo
) 

/*6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee.*/

UPDATE empleado SET nombre = 'Juan', apellido = 'Perez', direccion = 'Calle Falsa 123' WHERE DNI = 40568965

/*7. Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de
proyectos pero no han sido líderes de equipo.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM empleado e INNER JOIN proyecto p ON (e.DNI = p.DNIResponsable)
WHERE e.DNI NOT IN (
    SELECT DNILider
    FROM equipo
)

/*8. Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados
como equipos frontend y backend.*/ 

SELECT e.nombreE, e.descTecnologias
FROM equipo e INNER JOIN proyecto p ON (e.codEquipo = p.equipoBackend) 
INTERSECT
SELECT e.nombreE, e.descTecnologias
FROM equipo e INNER JOIN proyecto p ON (e.codEquipo = p.equipoFrontend)

/*9. Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos que
se estiman finalizar durante 2025.*/

SELECT p.nombreP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido
FROM proyecto p INNER JOIN empleado e ON (p.DNIResponsable = e.DNI)
WHERE (p.fechaFinEstimada BETWEEN '01/01/2025' AND '31/12/2025')


/*Proyecto = (codProyecto, nombrP,descripcion, fechaInicioP, fechaFinP, fechaFinEstimada,
DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK)) // DNIResponsable corresponde a un
empleado, equipoBackend y equipoFrontend corresponden a equipos
Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK))//DNILider corresponde a un empleado
Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
Empleado_Equipo = (codEquipo(FK, DNI(FK), fechaInicio, fechaFin, descripcionRol)*/