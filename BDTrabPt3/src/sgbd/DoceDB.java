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
import model.Doce;

/*CREATE TABLE DOCE (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO_UNIDADE NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO CHAR(256),
    CONSTRAINT PK_DOCE PRIMARY KEY(NOME),
    CONSTRAINT CK1_DOCE CHECK(PRECO_UNIDADE >= 0)
);*/

/**
 *
 * @author andre
 */
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
            ResultSet rs = st.executeQuery("SELECT NOME, MODEL, PRECO_UNIDADE, DESCRICAO FROM DOCE");

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

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}