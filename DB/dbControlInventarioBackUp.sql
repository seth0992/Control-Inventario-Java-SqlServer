USE [dbControlInventario]
GO
/****** Object:  Table [dbo].[tblCategoria]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategoria](
	[idCategoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCompra]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompra](
	[idCompra] [int] IDENTITY(1,1) NOT NULL,
	[fecha] [date] NULL,
	[cantidad] [int] NULL,
	[idProducto] [int] NULL,
	[idProveedor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProducto]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProducto](
	[idProducto] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](40) NOT NULL,
	[precio] [money] NULL,
	[stock] [int] NULL,
	[imagen] [varbinary](max) NULL,
	[idCategoria] [int] NULL,
	[idProveedor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProveedor]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProveedor](
	[idProveedor] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](150) NOT NULL,
	[direccion] [varchar](300) NULL,
	[telefono] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblProducto] ADD  DEFAULT ((0)) FOR [precio]
GO
ALTER TABLE [dbo].[tblCompra]  WITH CHECK ADD FOREIGN KEY([idProducto])
REFERENCES [dbo].[tblProducto] ([idProducto])
GO
ALTER TABLE [dbo].[tblCompra]  WITH CHECK ADD FOREIGN KEY([idProveedor])
REFERENCES [dbo].[tblProveedor] ([idProveedor])
GO
ALTER TABLE [dbo].[tblProducto]  WITH CHECK ADD FOREIGN KEY([idCategoria])
REFERENCES [dbo].[tblCategoria] ([idCategoria])
GO
ALTER TABLE [dbo].[tblProducto]  WITH CHECK ADD FOREIGN KEY([idProveedor])
REFERENCES [dbo].[tblProveedor] ([idProveedor])
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarProducto]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para modificar un producto
CREATE PROCEDURE [dbo].[sp_ActualizarProducto]
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
/****** Object:  StoredProcedure [dbo].[sp_AgregarProducto]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimientos almacenados

--Procedimientos para la tabla de productos
--Procedimiento para agregar un producto
CREATE   PROCEDURE [dbo].[sp_AgregarProducto]
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
/****** Object:  StoredProcedure [dbo].[sp_ConsultarProducto]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento  Consultar Producto con filtros
CREATE   PROCEDURE [dbo].[sp_ConsultarProducto]
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
/****** Object:  StoredProcedure [dbo].[sp_EliminarProducto]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para eliminar un producto
CREATE PROCEDURE [dbo].[sp_EliminarProducto]
@idProducto INT
AS
BEGIN
	DELETE FROM tblProducto WHERE idProducto = @idProducto	
END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarCategoria]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para modificar un categoría
CREATE   PROCEDURE [dbo].[spActualizarCategoria]
    @idCategoria INT,
    @nuevoNombre VARCHAR(60)
AS
BEGIN
    UPDATE tblCategoria
    SET nombre = @nuevoNombre
    WHERE idCategoria = @idCategoria;
END;
GO
/****** Object:  StoredProcedure [dbo].[spActualizarProveedor]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para modificar un proveedor
CREATE   PROCEDURE [dbo].[spActualizarProveedor]
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
/****** Object:  StoredProcedure [dbo].[spCrearCategoria]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimientos Almacenados de la tabla de Categorías
--Procedimiento para agregar una categoría
CREATE   PROCEDURE [dbo].[spCrearCategoria]
    @nombre VARCHAR(60)
AS
BEGIN
    INSERT INTO tblCategoria (nombre)
    VALUES (@nombre);
END;
GO
/****** Object:  StoredProcedure [dbo].[spCrearProveedor]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimientos Almacenados de la tabla de Proveedores
--Procedimiento para agregar una Proveedores
CREATE   PROCEDURE [dbo].[spCrearProveedor]
    @nombre VARCHAR(150),
    @direccion VARCHAR(300),
    @telefono VARCHAR(15)
AS
BEGIN
    INSERT INTO tblProveedor (nombre, direccion, telefono)
    VALUES (@nombre, @direccion, @telefono);
END;
GO
/****** Object:  StoredProcedure [dbo].[spEliminarCategoria]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para eliminar una categoría 
CREATE PROCEDURE [dbo].[spEliminarCategoria]
    @idCategoria INT
AS
BEGIN
    DELETE FROM tblCategoria
    WHERE idCategoria = @idCategoria;
END;
GO
/****** Object:  StoredProcedure [dbo].[spEliminarProveedor]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para eliminar un proveedor
CREATE   PROCEDURE [dbo].[spEliminarProveedor]
    @idProveedor INT
AS
BEGIN
    DELETE FROM tblProveedor
    WHERE idProveedor = @idProveedor;
END;
GO
/****** Object:  StoredProcedure [dbo].[spObtenerCategorias]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para consultar las categorias
CREATE PROCEDURE [dbo].[spObtenerCategorias]
@nombre VARCHAR(60) = NULL
AS
BEGIN
    SELECT * FROM tblCategoria WHERE (nombre LIKE '%' +@nombre+ '%' OR @nombre IS NULL);
END;
GO
/****** Object:  StoredProcedure [dbo].[spObtenerProveedores]    Script Date: 23/11/2023 05:31:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Procedimiento para consultar proveedores
CREATE PROCEDURE [dbo].[spObtenerProveedores]
@nombre VARCHAR(150) = NUll
AS
BEGIN
    SELECT * FROM tblProveedor WHERE (nombre LIKE '%' +@nombre+ '%' OR @nombre IS NULL);
END;
GO
