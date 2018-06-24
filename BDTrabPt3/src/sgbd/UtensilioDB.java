/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sgbd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.Utensilio;
//import static sun.misc.Version.print;


/*CREATE TABLE UTENSILIO (
    NOME VARCHAR2(40) NOT NULL,
    QTD_ESTOQUE NUMBER(12) DEFAULT 0 NOT NULL,
    TIPO CHAR(32) NOT NULL,
    CONSTRAINT PK_UTENSILIO PRIMARY KEY(NOME),
    CONSTRAINT CK1_UTENSILIO CHECK(QTD_ESTOQUE >= 0)
); */

<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class UtensilioDB {
    
    /**
     *
     * @return
     */
    public ArrayList<Utensilio> Utensilio_SelectAll() {
        ArrayList<Utensilio> utensilios = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT NOME, QTD_ESTOQUE, TIPO FROM UTENSILIO");

            while (rs.next()) {
                utensilios.add(new Utensilio(rs.getString(1), rs.getInt(2), rs.getString(3)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return utensilios;
    }
    
    public void Utensilio_Insert(Utensilio utensilio) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
<<<<<<< HEAD
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO) "
                    + "VALUES (" + utensilio.getNome() + ", " + utensilio.getQtdEstoque() + ", " + utensilio.getTipo() + ")");                               
            
=======
            PreparedStatement pst = con.prepareStatement("INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO) "
                    + "VALUES (?, ?, ?)");
            
            pst.setString(1, utensilio.getNome());
            pst.setInt(2, utensilio.getQtdEstoque());
            pst.setString(3, utensilio.getTipo());
            
            pst.executeUpdate();
>>>>>>> master
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Utensilio_Delete(Utensilio utensilio) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
<<<<<<< HEAD
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("DELETE FROM UTENSILIO WHERE NOME = " + utensilio.getNome());                               
            
=======
            PreparedStatement pst = con.prepareStatement("DELETE FROM UTENSILIO WHERE NOME = ?");
            
            pst.setString(1, utensilio.getNome());
            
            pst.executeUpdate();
>>>>>>> master
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Utensilio_Update(Utensilio utensilio, Utensilio updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE UTENSILIO "
                    + "SET QTD_ESTOQUE = ?, TIPO = ? " +
                    "WHERE NOME = ?");

            pst.setInt(1, updated.getQtdEstoque());
            pst.setString(2, updated.getTipo());
            pst.setString(3, utensilio.getNome());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
