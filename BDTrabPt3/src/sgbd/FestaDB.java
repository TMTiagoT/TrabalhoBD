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
import model.Festa;

/*CREATE TABLE FESTA (
    NRO_REGISTRO NUMBER(12) NOT NULL, --GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, --AUTO_INCREMENT ("NAO PODE SER ESCRITO"),
    NRO_CONVIDADOS NUMBER(12),
    ENDERECO VARCHAR2(240) NOT NULL,
    PRECO_FESTA NUMBER(12,2) DEFAULT 0 NOT NULL,
    TIPO CHAR(9) NOT NULL,
    DATA_HORA DATE NOT NULL,
    PRECO_TOTAL NUMBER(12,2) DEFAULT 0, --ATRIBUTO DERIVADO
    CLIENTE_CPF CHAR(14),
    CONSTRAINT PK_FESTA PRIMARY KEY(NRO_REGISTRO),
    CONSTRAINT FK_FESTA_CLIENTE FOREIGN KEY(CLIENTE_CPF)
            REFERENCES CLIENTE(CPF)
            ON DELETE SET NULL,
    CONSTRAINT CK1_FESTA CHECK(TIPO IN ('CASAMENTO', 'FORMATURA')),
    CONSTRAINT CK2_FESTA CHECK(NRO_CONVIDADOS IS NULL OR NRO_CONVIDADOS >= 0),
    CONSTRAINT CK3_FESTA CHECK(PRECO_FESTA >= 0)
); */

/**
 *
 * @author andre
 */
public class FestaDB {
    
    /**
     *
     * @return
     */
    public ArrayList<Festa> Festa_SelectAll() {
        ArrayList<Festa> festas = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT NRO_REGISTRO, NRO_CONVIDADES, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF FROM FESTA");

            while (rs.next()) {
                festas.add(new Festa(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getDouble(4), rs.getString(5), rs.getString(6), rs.getDouble(7), rs.getString(8)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return festas;
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
