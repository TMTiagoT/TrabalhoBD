/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sgbd;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.Bolo;

/*CREATE TABLE BOLO (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    CONSTRAINT PK_BOLO PRIMARY KEY(NOME),
    CONSTRAINT CK1_BOLO CHECK(PRECO >= 0)
);*/


/**
 *
 * @author andre
 */
public class BoloDB {
    
    /**
     *
     * @return
     */
    public ArrayList<Bolo> Bolo_SelectAll() {
        ArrayList<Bolo> bolos = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT NOME, MODELO, PRECO, DESCRICAO FROM BOLO");

            while (rs.next()) {
                bolos.add(new Bolo(rs.getString(1), rs.getString(2), rs.getDouble(3), rs.getString(4)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return bolos;
    }
    
    public void Bolo_Insert(Bolo bolo) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("INSERT INTO BOLO (NOME, MODELO, PRECO, DESCRICAO) "
                    + "VALUES (" + bolo.getNome() + ", " + bolo.getModelo() + ", " + bolo.getPreco() + ", " + bolo.getDescricao() + ")");
            
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Bolo_Delete(Bolo bolo) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("DELETE FROM BOLO WHERE NOME = " + bolo.getNome());
            
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Bolo_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
