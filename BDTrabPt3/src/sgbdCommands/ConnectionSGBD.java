/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sgbdCommands;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConnectionSGBD {

    public static Connection getConnection() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String myDB = "jdbc:oracle:thin:@grad.icmc.usp.br:15215:orcl";
            String user = "T9778992";
            String password = "t9778992";

            Connection con = DriverManager.getConnection(myDB, user, password);

            return con;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException e) {
            Logger.getLogger(ConnectionSGBD.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return null;
    }

    public static void CloseConnection(Connection con) {
        if(con == null) return;
        
        try {
            con.close();
        } catch (SQLException e) {
            Logger.getLogger(ConnectionSGBD.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
