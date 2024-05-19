USE master;
GO

CREATE DATABASE Bodega;
GO

USE Bodega;
GO


CREATE TABLE PRODUCTO
(
    idprod CHAR(7) PRIMARY KEY,
    descripcion VARCHAR(25),
    existencias int,
    precio DECIMAL(10,2) NOT NULL,
    preciov DECIMAL(10,2) NOT NULL,
    ganancias as preciov - precio,
    CHECK(preciov>precio)
)
GO

CREATE TABLE PEDIDO
(
    idpedido CHAR(7),
    idprod CHAR(7),
    cantidad INT
        FOREIGN KEY (idprod) REFERENCES PRODUCTO(idprod)
)
GO

INSERT INTO PRODUCTO
    (idprod, descripcion, existencias, precio, preciov)
VALUES
    ('P001', 'Camiseta', 50, 15.00, 25.00),
    ('P002', 'Pantalón', 30, 20.00, 35.00),
    ('P003', 'Zapatos', 20, 40.00, 60.00),
    ('P004', 'Gorra', 40, 10.00, 18.00),
    ('P005', 'Bufanda', 25, 12.00, 22.00),
    ('P006', 'Calcetines', 50, 5.00, 8.00),
    ('P007', 'Guantes', 35, 8.00, 15.00),
    ('P008', 'Chaqueta', 15, 50.00, 80.00),
    ('P009', 'Vestido', 10, 45.00, 70.00),
    ('P010', 'Sombrero', 20, 18.00, 30.00);
GO

INSERT INTO PEDIDO
    (idpedido, idprod, cantidad)
VALUES
    ('PD001', 'P001', 5),
    ('PD002', 'P003', 2),
    ('PD003', 'P005', 10),
    ('PD004', 'P002', 3),
    ('PD005', 'P006', 8),
    ('PD006', 'P008', 1),
    ('PD007', 'P009', 2),
    ('PD008', 'P007', 5),
    ('PD009', 'P004', 4),
    ('PD010', 'P010', 7);
GO

CREATE TABLE BITACORA
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    accion VARCHAR(50),
    fecha DATETIME,
    nombre_producto VARCHAR(25),
    nombre_usuario VARCHAR(50)
);
GO


SELECT *
FROM PRODUCTO;
GO

SELECT *
FROM PEDIDO;
GO

SELECT *
FROM BITACORA;
GO

--Consulta de un procedemiento almacenado  que ingrese los valores en la tabla PRODUCTOS, y
--deberá verificar que el código y nombre del producto no exista para poder insertarlo, en
--caso de que el código o el nombre del producto ya exista enviar un mensaje que diga “ESTE
--PRODUCTO YA HA SIDO INGRESADO”.

CREATE PROC Insert_Product
@idprod CHAR(7),
@descripcion VARCHAR(25),
@existencias INT,
@precio DECIMAL (10,2),
@preciov DECIMAL (10,2)
AS
BEGIN
IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE idprod = @idprod OR descripcion = @descripcion)
    BEGIN
        INSERT INTO PRODUCTO(idprod, descripcion, existencias, precio, preciov)
        VALUES(@idprod, @descripcion, @existencias, @precio, @preciov)
    END
ELSE
    BEGIN
    RAISERROR ('ESTE PRODUCTO YA HA SIDO INGRESADO', -1, -1)
    END
END
GO
/*
Crear un procedimiento almacenado que permita realizar un pedido EN LA TABLA PEDIDO, 
este procedimiento deberá verificar si el código del producto ingresado existe en la tabla 
PRODUCTO en caso de que no se encuentre deberá mostrar un mensaje, así como se 
muestra a continuación “ESTE PRODUCTO NO EXISTE “, además si la cantidad a pedir del 
producto es mayor a la existencia del producto deberá mostrar un mensaje que diga 
“EXISTENCIA DEL PRODUCTO INSUFICIENTE”. En caso de que la cantidad a pedir sea menor 
o igual deberá modificar (o actualizar) el valor de la existencia del producto. 
*/

CREATE PROCEDURE RealizarPedido    @idpedido CHAR(7),    @idprod CHAR(7),    @cantidad INTASBEGIN    -- Verificar existencia    IF NOT EXISTS (SELECT 1 FROM PRODUCTO WHERE idprod = @idprod)    BEGIN        PRINT 'ESTE PRODUCTO NO EXISTE';        RETURN;    END    -- Verificar si la cantidad a pedir es mayor que la existencia del producto    DECLARE @existencias INT;    SELECT @existencias = existencias FROM PRODUCTO WHERE idprod = @idprod;    IF @cantidad > @existencias    BEGIN        PRINT 'EXISTENCIA DEL PRODUCTO INSUFICIENTE';        RETURN;    END    -- Insertar el pedido en la tabla PEDIDO    INSERT INTO PEDIDO (idpedido, idprod, cantidad)    VALUES (@idpedido, @idprod, @cantidad);    -- Actualizar la existencia    UPDATE PRODUCTO    SET existencias = existencias - @cantidad    WHERE idprod = @idprod;    PRINT 'PEDIDO REALIZADO CON EXITO';END;GO

-- Consultas para la base de datos Northwind
USE Northwind;
GO

-- Consulta que muestra la cantidad de productos que existen dentro de cada categoría
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS ProductCount
FROM Categories
    JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;
GO

--Consulta que muestra el nombre completo del vendedor, 
--la fecha de orden, el nombre del producto y la cantidad vendida
SELECT
    CONCAT(Employees.FirstName, ' ', Employees.LastName) AS SalesPerson,
    Orders.OrderDate,
    Products.ProductName,
    [Order Details].Quantity
FROM Orders
    JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
    JOIN Products ON [Order Details].ProductID = Products.ProductID
    JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID;

--Consulta que muestra el nombre y la primera inicial del apellido 
--del vendedor junto con la suma total de todas sus ventas, de los vendedores que tengan 
--un total de ventas mayor a 100,000
SELECT
    Employees.FirstName + ' ' + LEFT(Employees.LastName, 1) AS CompleteName,
    SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalSales
FROM Orders
    JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
    JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName
HAVING SUM([Order Details].UnitPrice * [Order Details].Quantity) > 100000;


/*
3. Triggers en la tabla Productos que se active al momento de realizar una
inserción, eliminación o actualización de datos. Dicha actualización deberá guardarse en una
tabla que se llame BITACORA, la cual contiene un id, la acción que se realizó, la fecha y el
nombre del usuario que realizó la acción.
*/
--Disparador de INSERT
ALTER TRIGGER [dbo].[trg_producto_bitacoraINSERT]
ON [dbo].[PRODUCTO] 
FOR INSERT
AS
BEGIN
INSERT INTO BITACORA (accion, fecha, nombre_producto, nombre_usuario)
select 'Insertar' , GETDATE(),descripcion,SUSER_NAME() FROM inserted
end;


--Disparador de DELETE
ALTER TRIGGER [dbo].[trg_producto_bitacoraDELETE]
ON [dbo].[PRODUCTO] 
FOR DELETE
AS
BEGIN
INSERT INTO BITACORA (accion, fecha, nombre_producto, nombre_usuario)
select 'Eliminar' , GETDATE(),descripcion,SUSER_NAME() FROM inserted
end;


--Disparador de UPDATE
ALTER TRIGGER [dbo].[trg_producto_bitacoraUPDATE]
ON [dbo].[PRODUCTO] 
FOR UPDATE
AS
BEGIN
INSERT INTO BITACORA (accion, fecha, nombre_producto, nombre_usuario)
select 'Actualizar' , GETDATE(),descripcion,SUSER_NAME() FROM inserted
end;







