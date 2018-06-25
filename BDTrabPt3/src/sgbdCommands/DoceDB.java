/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sgbdCommands;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.Doce;

/*CREATE TABLE DOCE (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO_UNIDADE NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO CHAR(256),
    CONSTRAINT PK_DOCE PRIMARY KEY(NOME),
    CONSTRAINT CK1_DOCE CHECK(PRECO_UNIDADE >= 0)
);*/

public class DoceDB {
    
        /**
     *
     * @return
     */
    public ArrayList<Doce> Doce_SelectAll() {
        ArrayList<Doce> doces = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT NOME, MODELO, PRECO_UNIDADE, DESCRICAO FROM DOCE");

            while (rs.next()) {
                doces.add(new Doce(rs.getString(1), rs.getString(2), rs.getDouble(3), rs.getString(4)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return doces;
    }
    
    public void Doce_Insert(Doce doce) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("INSERT INTO BOLO (NOME, MODELO, PRECO_UNIDADE, DESCRICAO) "
                    + "VALUES (?, ?, ?, ?)");
            
            pst.setString(1, doce.getNome());
            pst.setString(2, doce.getModelo());
            pst.setDouble(3, doce.getPrecoUnidade());
            pst.setString(4, doce.getDescricao());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Doce_Delete(Doce doce) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("DELETE FROM DOCE WHERE NOME = ?");
            
            pst.setString(1, doce.getNome());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
     public void Doce_Update(Doce doce, Doce updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE DOCE "
                    + "SET MODELO = ?, PRECO_UNIDADE = ?, DESCRICAO = ?" +
                    "WHERE NOME = ?");

            pst.setString(1, updated.getModelo());
            pst.setDouble(2, updated.getPrecoUnidade());
            pst.setString(3, updated.getDescricao());
            pst.setString(4, doce.getNome());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Doce_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
