CREATE DATABASE dbControlInventario;
GO

USE dbControlInventario;
GO

--Tabla de control de Categorias
CREATE TABLE tblCategoria(
	idCategoria INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(60) NOT NULL
);
GO

--Tabla de control de Proveedores
CREATE TABLE tblProveedor(
	idProveedor INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(150) NOT NULL,
	direccion VARCHAR(300) NULL,
	telefono VARCHAR(15) NOT NULL
);
GO

--Tabla de control de Productos
CREATE TABLE tblProducto(
	idProducto INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(40) NOT NULL,
	precio MONEY DEFAULT 0,
	stock INT,
	imagen VARBINARY(MAX),
	idCategoria INT FOREIGN KEY REFERENCES tblCategoria(idCategoria),
	idProveedor INT FOREIGN KEY REFERENCES tblProveedor(idProveedor)
);
GO

--Tabla de control de las ordenes de compra
CREATE TABLE tblCompra(
	idCompra INT PRIMARY KEY IDENTITY,
	fecha DATE,
	cantidad INT,
	idProducto INT FOREIGN KEY REFERENCES tblProducto(idProducto),
	idProveedor INT FOREIGN KEY REFERENCES tblProveedor(idProveedor)
);
GO

-- Procedimientos almacenados

--Procedimientos para la tabla de productos
--Procedimiento para agregar un producto
CREATE or ALTER PROCEDURE sp_AgregarProducto
@nombreProducto VARCHAR(40),
@precio MONEY,
@cantidad INT,
@imagen VARBINARY(MAX),
@idCategoria INT,
@idProveedor INT
AS
BEGIN
	
	INSERT INTO tblProducto (nombre,precio,stock,imagen,idCategoria,idProveedor) 
		VALUES (@nombreProducto,@precio,@cantidad,@imagen,@idCategoria,@idProveedor)

END
GO

--Procedimiento para modificar un producto
CREATE PROCEDURE sp_ActualizarProducto
@idProducto INT,
@nombreProducto VARCHAR(40),
@precio MONEY,
@cantidad INT,
@imagen VARBINARY(MAX),
@idCategoria INT,
@idProveedor INT
AS
BEGIN
	
	UPDATE tblProducto SET nombre = @nombreProducto, precio = @precio,
		stock = @cantidad, imagen= @imagen, idCategoria = @idCategoria, idProveedor= @idProveedor 
		WHERE idProducto = @idProducto	

END
GO

-- Procedimiento para eliminar un producto
CREATE PROCEDURE sp_EliminarProducto
@idProducto INT
AS
BEGIN
	DELETE FROM tblProducto WHERE idProducto = @idProducto	
END
GO

-- Procedimiento  Consultar Producto con filtros
CREATE or ALTER PROCEDURE sp_ConsultarProducto
@idProveedor INT = NULL,
@idCategoria INT = NULL,
@nombre VARCHAR(40) = NULL
AS 
BEGIN
	
	SELECT prod.idProducto, prod.nombre [producto], prod.precio, prod.stock, prod.imagen, prod.idCategoria, cat.nombre [categoria], prod.idproveedor, prov.nombre [proveedor]
	FROM tblProducto prod 
	INNER JOIN tblCategoria cat ON prod.idCategoria = cat.idCategoria 
	INNER JOIN tblProveedor prov ON prov.idProveedor = prod.idProveedor  
	WHERE 
		(prod.idProveedor = @idProveedor OR @idProveedor IS NULL) AND 
		(prod.idCategoria = @idCategoria OR @idCategoria IS NULL) AND 
		(prod.nombre LIKE '%'+@nombre+'%'OR @nombre IS NULL);
END;
GO

--Procedimientos Almacenados de la tabla de Categorías
--Procedimiento para agregar una categoría
CREATE OR ALTER PROCEDURE spCrearCategoria
    @nombre VARCHAR(60)
AS
BEGIN
    INSERT INTO tblCategoria (nombre)
    VALUES (@nombre);
END;
GO

--Procedimiento para modificar un categoría
CREATE or ALTER PROCEDURE spActualizarCategoria
    @idCategoria INT,
    @nuevoNombre VARCHAR(60)
AS
BEGIN
    UPDATE tblCategoria
    SET nombre = @nuevoNombre
    WHERE idCategoria = @idCategoria;
END;
GO

--Procedimiento para eliminar una categoría 
CREATE PROCEDURE spEliminarCategoria
    @idCategoria INT
AS
BEGIN
    DELETE FROM tblCategoria
    WHERE idCategoria = @idCategoria;
END;
GO

--Procedimiento para consultar las categorias
CREATE PROCEDURE spObtenerCategorias
@nombre VARCHAR(60) = NULL
AS
BEGIN
    SELECT * FROM tblCategoria WHERE (nombre LIKE '%' +@nombre+ '%' OR @nombre IS NULL);
END;
GO

--Procedimientos Almacenados de la tabla de Proveedores
--Procedimiento para agregar una Proveedores
CREATE or ALTER PROCEDURE spCrearProveedor
    @nombre VARCHAR(150),
    @direccion VARCHAR(300),
    @telefono VARCHAR(15)
AS
BEGIN
    INSERT INTO tblProveedor (nombre, direccion, telefono)
    VALUES (@nombre, @direccion, @telefono);
END;
GO

--Procedimiento para modificar un proveedor
CREATE or ALTER PROCEDURE spActualizarProveedor
    @idProveedor INT,
    @nuevoNombre VARCHAR(150),
    @nuevaDireccion VARCHAR(300),
    @nuevoTelefono VARCHAR(15)
AS
BEGIN
    UPDATE tblProveedor
    SET nombre = @nuevoNombre,
        direccion = @nuevaDireccion,
        telefono = @nuevoTelefono
    WHERE idProveedor = @idProveedor;
END;
GO

--Procedimiento para eliminar un proveedor
CREATE OR ALTER PROCEDURE spEliminarProveedor
    @idProveedor INT
AS
BEGIN
    DELETE FROM tblProveedor
    WHERE idProveedor = @idProveedor;
END;
GO

--Procedimiento para consultar proveedores
CREATE PROCEDURE spObtenerProveedores
@nombre VARCHAR(150) = NUll
AS
BEGIN
    SELECT * FROM tblProveedor WHERE (nombre LIKE '%' +@nombre+ '%' OR @nombre IS NULL);
END;
GO
