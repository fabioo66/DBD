/*Ejercicio 1
Cliente(idCliente, nombre, apellido, DNI, telefono, direccion)
Factura (nroTicket, total, fecha, hora,idCliente (fk))
Detalle(nroTicket, idProducto, cantidad, preciounitario)
Producto(idProducto, descripcion, precio, nombreP, stock)*/

/*1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI*/

SELECT nombre, apellido, DNI, telefono, direccion
FROM cliente
WHERE apellido LIKE 'Pe%'
ORDER BY DNI;

/*2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente durante 2017.*/

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion 
FROM cliente c INNER JOIN factura f ON (cliente.idCliente = factura.idCliente)
WHERE (f.fecha BETWEEN '01/01/2017' AND '31/12/2017')
EXCEPT (
    SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
    FROM cliente c INNER JOIN factura f ON (cliente.idCliente = factura.idCliente)
    WHERE (f.fecha < '01/01/2017' and f.fecha > '31/12/2017')
)

/*3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’*/

SELECT nombreP, descripcion, precio, stock 
FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto 
WHERE (dni = 45789456) 
EXCEPT (
    SELECT nombreP, descripcion, precio, stock 
    FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto 
    WHERE (apellido = 'Garcia') 
)

/*4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre.*/

SELECT nombreP, descripcion, precio, stock
FROM producto
WHERE idProducto NOT in (
    SELECT 
    nombreP, descripcion, precio, stock
    FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto 
    WHERE (telefono LIKE '221%') 
)

/*5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto.*/

SELECT nombreP, descripcion, precio, stock, COUNT(*) as CANTIDAD
FROM producto NATURAL JOIN detalle
GROUP BY idProducto, nombreP, descripcion, precio, stock

/*6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’*/

SELECT nombre, apellido, DNIm telefono, direccion
FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
WHERE (nombreP = 'prod1') 
UNION
SELECT nombre, apellido, DNIm telefono, direccion
FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
WHERE (nombreP = 'prod2')
EXCEPT(
    SELECT nombre, apellido, DNIm telefono, direccion
    FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
    WHERE (nombreP = 'prod3')
)

/*7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2019.*/

SELECT nroTicket, total, fecha, hora, DNI
FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
WHERE (nombreP = 'prod38') OR (fecha BETWEEN '01/01/2019' AND '31/12/2019')

/*8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe.*/

INSERT INTO cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
VALUES (500002, 'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 y 501 nro:2587')

/*9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya
comprado el producto ´Z´.*/

SELECT nroTicket, total, fecha, hora
FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
WHERE (nombre = 'Jorge' AND apellido = 'Pérez')
EXCEPT(
    SELECT nroTicket, total, fecha, hora
    FROM cliente NATURAL JOIN factura NATURAL JOIN detalle NATURAL JOIN producto
    WHERE (nombreP = 'Z')
)

/*10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $10.000.000.*/

SELECT DNI, apellido, nombre
FROM cliente NATURAL JOIN factura
GROUP BY DNI, apellido, nombre
HAVING SUM(total) > 10000000