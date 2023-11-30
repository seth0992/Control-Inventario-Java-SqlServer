/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloJDBC;

import ConexionBD.conexionSQLServer;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Seth
 */
public class ProveedorJDBC {

    private final String SQL_INSERT_SP = "{CALL spCrearProveedor(?,?,?)}";
    private final String SQL_UPDATE_SP = "{CALL spActualizarProveedor(?,?,?,?)}";
    private final String SQL_DELETE_SP = "{CALL spEliminarProveedor(?)}";
    private final String SQL_SELECT_SP = "{CALL spObtenerProveedores(?)}";

    //Método para registrar la Proveedor
    public int registrarProveedor(String nombreProv, String direccionProv, String telefonoProv) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_INSERT_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setString(1, nombreProv);
            cstmt.setString(2, direccionProv);
            cstmt.setString(3, telefonoProv);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la Registro de Proveedor");
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

    //Método para modificar Proveedor
    public int modificarProv(int idProv, String nombreProv, String direccionProv, String telefonoProv) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_UPDATE_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setInt(1, idProv);
            cstmt.setString(2, nombreProv);
            cstmt.setString(3, direccionProv);
            cstmt.setString(4, telefonoProv);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la Modifico el proveedor");
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

    //Método para eliminar proveedor
    public int eliminarProveedor(int idProv) {

        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;

        int filaAfectadas = 0;

        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_DELETE_SP); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setInt(1, idProv);

            //Se ejecuta la consulta
            System.out.println("Ejecutando la elimino el proveedor");
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

    //Método para obtener las proveedores
    public DefaultTableModel consultarProveedores(String nombreProv) {
        //Objeto de conexión
        Connection conn = null;
        // prepareCall -> para realizar el llamado del procedimiento almacenado
        CallableStatement cstmt = null;
        ResultSet rs = null;

        //Creación del modelo de la tabla
        DefaultTableModel modeloTabla = new DefaultTableModel();
        modeloTabla.addColumn("ID");
        modeloTabla.addColumn("Nombre");
        modeloTabla.addColumn("Dirección");
        modeloTabla.addColumn("Teléfono");
        
        try {

            conn = conexionSQLServer.getConnection(); //Se obtiene la conexion desde la clase Conexion SQL Server
            cstmt = conn.prepareCall(SQL_SELECT_SP, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); //Se prepara la llamada al procedimiento 

            //Se Sustituye los valores a enviar en el procedimiento almacenado
            cstmt.setString(1, nombreProv);

            //Se ejecuta la consulta
            System.out.println("Ejecutando consulta de Proveedor");
            boolean resultado = cstmt.execute();

            // Comprobar si hay un conjunto de resultados
            if (resultado) {
                // Devolver el conjunto de resultados
                rs = cstmt.getResultSet();
                while (rs.next()) {
                    // Acceder a los datos de cada fila
                    int id = rs.getInt("idProveedor");
                    String nombre = rs.getString("nombre");
                     String direccion = rs.getString("direccion");
                      String telefono = rs.getString("telefono");
                    modeloTabla.addRow(new Object[]{id, nombre,direccion, telefono});
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
}
