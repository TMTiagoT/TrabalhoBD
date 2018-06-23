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
import model.UtensilioFesta;

/*CREATE TABLE UTENSILIO_FESTA (
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    UTENSILIO_NOME VARCHAR2(40) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_UTENSILIO_FESTA PRIMARY KEY(FESTA_NRO_REGISTRO, UTENSILIO_NOME),
    CONSTRAINT FK_UTENSILIO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT FK_UTENSILIO_FESTA_UTENSILIO FOREIGN KEY(UTENSILIO_NOME)
                REFERENCES UTENSILIO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_UTENSILIO_FESTA CHECK(QUANTIDADE >= 0)
); */

/**
 *
 * @author andre
 */
public class UtensilioFestaDB {
    
    /**
     *
     * @return
     */
    public ArrayList<UtensilioFesta> UtensilioFesta_SelectAll() {
        ArrayList<UtensilioFesta> utensiliosFesta = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE FROM UTENSILIO_FESTA");

            while (rs.next()) {
                utensiliosFesta.add(new UtensilioFesta(rs.getInt(1), rs.getString(2), rs.getInt(3)));
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

        return utensiliosFesta;
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
