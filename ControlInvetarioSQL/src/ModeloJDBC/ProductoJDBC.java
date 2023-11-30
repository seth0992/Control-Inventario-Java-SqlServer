package ModeloJDBC;

import ConexionBD.conexionSQLServer;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Seth
 */
public class ProductoJDBC {

    private final String SQL_INSERT_SP = "{CALL sp_AgregarProducto(?,?,?,?,?,?)}";
    private final String SQL_UPDATE_SP = "{CALL spActualizarProveedor(?,?,?,?,?,?,?)}";
    private final String SQL_DELETE_SP = "{CALL sp_EliminarProducto(?)}";
    private final String SQL_SELECT_SP = "{CALL sp_ConsultarProducto(?,?,?)}";

    //Método para registrar la productos
    public int registrarProducto(String nombreProd, BigDecimal precio, int cantidad, byte[] image, int idCategoria, int idProveedor) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_INSERT_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setString(1, nombreProd);
            cstmt.setBigDecimal(2, precio);
            cstmt.setInt(3, cantidad);
            cstmt.setBytes(4, image);
            cstmt.setInt(5, idCategoria);
            cstmt.setInt(6, idProveedor);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la Registro de Producto");
            cstmt.execute();
            filaAfectadas = cstmt.getUpdateCount();

        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            conexionSQLServer.close(cstmt);
            conexionSQLServer.close(conn);
        }

        return filaAfectadas;

    }

    //Método para modificar productos
    public int modificarProd(int idProd, String nombreProd, BigDecimal precio, int cantidad, byte[] image, int idCategoria, int idProveedor) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_UPDATE_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setInt(1, idProd);
            cstmt.setString(2, nombreProd);
            cstmt.setBigDecimal(3, precio);
            cstmt.setInt(4, cantidad);
            cstmt.setBytes(5, image);
            cstmt.setInt(6, idCategoria);
            cstmt.setInt(7, idProveedor);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la Modifico el Producto");
            cstmt.execute();
            filaAfectadas = cstmt.getUpdateCount();

        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            conexionSQLServer.close(cstmt);
            conexionSQLServer.close(conn);
        }

        return filaAfectadas;

    }

    //Método para eliminar productos
    public int eliminarProd(int idProd) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_DELETE_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setInt(1, idProd);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la elimino el productos");
            cstmt.execute();
            filaAfectadas = cstmt.getUpdateCount();

        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            conexionSQLServer.close(cstmt);
            conexionSQLServer.close(conn);
        }

        return filaAfectadas;
    }

    //Método para obtener las productos
    public DefaultTableModel consultarProd(Integer idCategoria, Integer idProveedor, String nombreProd) {
        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;
        ResultSet rs = null;

        //Creación del modelo de la tabla
        DefaultTableModel modeloTabla = new DefaultTableModel() {
            @Override
            public Class<?> getColumnClass(int columnIndex) {
                if (columnIndex == 4) { // Índice de la columna de la imagen
                    return ImageIcon.class;
                }
                return super.getColumnClass(columnIndex);
            }

            @Override
            public boolean isCellEditable(int row, int column) {
                // Puedes ajustar esto según tus necesidades
                return false;
            }
        };

        modeloTabla.addColumn("ID");
        modeloTabla.addColumn("Producto");
        modeloTabla.addColumn("Precio");
        modeloTabla.addColumn("Stock");
        modeloTabla.addColumn("Imagen");
        modeloTabla.addColumn("ID Categoría");
        modeloTabla.addColumn("Categoria");
        modeloTabla.addColumn("ID Proveedor");
        modeloTabla.addColumn("Proveedor");

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_SELECT_SP, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setObject(1, idProveedor);
            cstmt.setObject(2, idCategoria);
            cstmt.setString(3, nombreProd);

            //Se ejecuta la consulta
            System.out.println("Ejecutando consulta de Producto");
            boolean resultado = cstmt.execute();

            // Comprobar si hay un conjunto de resultados
            if (resultado) {
                // Devolver el conjunto de resultados
                rs = cstmt.getResultSet();
                while (rs.next()) {
                    // Acceder a los datos de cada fila
                    int id = rs.getInt("idProducto");
                    String nombre = rs.getString("producto");
                    BigDecimal precio = rs.getBigDecimal("precio");
                    int stock = rs.getInt("stock");
                    byte[] image = rs.getBytes("imagen");
                    int idCat = rs.getInt("idCategoria");
                    String categoria = rs.getString("categoria");
                    int idProve = rs.getInt("idproveedor");
                    String prove = rs.getString("proveedor");

                    modeloTabla.addRow(new Object[]{id, nombre, precio, stock, bytesToImageIcon(image), idCat, categoria, idProve, prove});
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            conexionSQLServer.close(cstmt);
            conexionSQLServer.close(conn);
            conexionSQLServer.close(rs);
        }

        return modeloTabla;
    }

    // Método para convertir bytes de imagen a ImageIcon
    private ImageIcon bytesToImageIcon(byte[] imageData) {
        try {
            BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(imageData));
            Image scaledImage = bufferedImage.getScaledInstance(50, 50, Image.SCALE_SMOOTH);
            return new ImageIcon(scaledImage);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
