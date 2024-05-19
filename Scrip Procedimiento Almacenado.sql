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