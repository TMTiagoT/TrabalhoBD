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
import model.Alimento;

/*CREATE TABLE ALIMENTO (
    NOME VARCHAR2(40) NOT NULL,
    PRECO_PESSOA NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    TIPO_ALIMENTO CHAR(6) NOT NULL,
    PRONTO NUMBER(1) DEFAULT 0 NOT NULL,
    TIPO_COMIDA_BEBIDA CHAR(15) NOT NULL,
    CONSTRAINT PK_ALIMENTO PRIMARY KEY(NOME),
    CONSTRAINT CK_ALIMENTO_TIPO_ALIMENTO CHECK((TIPO_ALIMENTO IN ('COMIDA')
                AND TIPO_COMIDA_BEBIDA IN ('ENTRADA', 'GUARNICAO', 'SALGADO', 'APERITIVO', 'MOLHO', 'SOBREMESA', 'PRATO PRINCIPAL'))
                OR (TIPO_ALIMENTO IN ('BEBIDA')
                AND TIPO_COMIDA_BEBIDA IN ('NAO ALCOOLICA', 'ALCOOLICA'))),
    CONSTRAINT CK1_ALIMENTO CHECK(PRECO_PESSOA >= 0),
    CONSTRAINT CK2_ALIMENTO CHECK(PRONTO IN (0, 1))
); */

/**
 *
 * @author andre
 */
public class AlimentoDB {
    
    /**
     *
     * @return
     */
    public ArrayList<Alimento> Alimento_SelectAll() {
        ArrayList<Alimento> alimentos = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT NOME, PRECO_PESSOA, DESCRICAO, TIPO_ALIMENTO, PRONTO, TIPO_COMIDA_BEBIDA FROM ALIMENTO");

            while (rs.next()) {
                alimentos.add(new Alimento(rs.getString(1), rs.getDouble(2), rs.getString(3), rs.getString(4), rs.getInt(5), rs.getString(6)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return alimentos;
    }
    
    public void Alimento_Insert(Alimento alimento) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("INSERT INTO ALIMENTO (NOME, PRECO_PESSOA, DESCRICAO, TIPO_ALIMENTO, PRONTO, TIPO_COMIDA_BEBIDA) "
                    + "VALUES (" + alimento.getNome() + ", " + alimento.getPrecoPessoa() + ", " + alimento.getDescricao() + ", " + alimento.getTipoAlimento() + ", " + alimento.isPronto() + ", " + alimento.getTipoComidaBebida() + ")");
            
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Alimento_Delete(Alimento alimento) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("DELETE FROM ALIMENTO WHERE NOME = " + alimento.getNome());
            
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Alimento_Update(Alimento alimento, Alimento updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE ALIMENTO "
                    + "SET PRECO_PESSOA = ?, DESCRICAO = ?, TIPO_ALIMENTO = ?, PRONTO = ?, TIPO_COMIDA_BEBIDA = ? " +
                    "WHERE NOME = ?");

            pst.setDouble(1, updated.getPrecoPessoa());
            pst.setString(2, updated.getDescricao());
            pst.setString(3, updated.getTipoAlimento());
            pst.setBoolean(4, updated.isPronto());
            pst.setString(5, updated.getTipoComidaBebida());
            pst.setString(6, alimento.getNome());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Alimento_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
