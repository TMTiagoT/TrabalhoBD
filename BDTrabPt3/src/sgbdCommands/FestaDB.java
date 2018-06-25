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
    
    public void Festa_Insert(Festa festa) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, CLIENTE_CPF) "
                    + "VALUES (?, ?, ?, ?, TO_DATE(?, 'DD-MM-YYYY HH:MI:SS'), ?)");
            
            pst.setInt(1, festa.getNroConvidados());
            pst.setString(2, festa.getEndereco());
            pst.setDouble(3, festa.getPrecoFesta());
            pst.setString(4, festa.getTipo());
            pst.setString(5, festa.getDataHora());
            pst.setString(6, festa.getClienteCpf());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Festa_Delete(Festa festa) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("DELETE FROM FESTA WHERE NRO_REGISTRO = ?");                             
            
            pst.setInt(1, festa.getNroRegistro());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Festa_Update(Festa festa, Festa updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE FESTA "
                    + "SET NRO_CONVIDADOS = ?, ENDERECO = ?, TIPO = ?, DATA_HORA = TO_DATE(?, 'DD-MM-YYYY HH:MI:SS'), CLIENTE_CPF = ? " +
                    "WHERE NRO_REGISTRO = ?");

            pst.setInt(1, updated.getNroConvidados());
            pst.setString(2, updated.getEndereco());
            pst.setString(3, updated.getTipo());
            pst.setString(4, updated.getDataHora());
            pst.setString(5, updated.getClienteCpf());
            pst.setInt(6, festa.getNroRegistro());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Festa_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
