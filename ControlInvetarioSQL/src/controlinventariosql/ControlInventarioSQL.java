/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package controlinventariosql;

import ConexionBD.conexionSQLServer;
import com.formdev.flatlaf.FlatLightLaf;
import gui.frmMenuGeneral;
import java.sql.Connection;
import java.sql.SQLException;
import javax.swing.UIManager;

/**
 *
 * @author Seth
 */
public class ControlInventarioSQL {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
       
     try{
         //Se utiliza el UI Manager para cambiar el estilo gráfico de la ventanas (look and feel)
        UIManager.setLookAndFeel( new FlatLightLaf() );
      }catch(Exception ex){
           System.err.println( "Fallo al cargar el look and feel" );
      }
      
     //Se crea una instancia del menu general y se vuelve visible.
        frmMenuGeneral menu = new frmMenuGeneral();
        menu.setLocationRelativeTo(null);
        menu.setVisible(true);
        
        //testConexion();
    }
    
    public static void testConexion(){
     Connection conexion = null;

        try {
            // Obtén la conexión utilizando el método getConnection de la clase conexionSQLServer
            conexion = conexionSQLServer.getConnection();

            // Si no se lanzó ninguna excepción, la conexión fue exitosa
            System.out.println("Conexión exitosa a la base de datos");
        } catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos");
            e.printStackTrace();
        } finally {
            // Asegúrate de cerrar la conexión al finalizar
            conexionSQLServer.close(conexion);
        }
    }
    
}
