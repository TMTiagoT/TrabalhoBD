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
import model.UtensilioFesta;

/*CREATE TABLE UTENSILIO_FESTA (
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    UTENSILIO_NOME VARCHAR2(40) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_UTENSILIO_FESTA PRIMARY KEY(FESTA_NRO_REGISTRO, UTENSILIO_NOME), --chave primaria da tabela
    CONSTRAINT FK_UTENSILIO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT FK_UTENSILIO_FESTA_UTENSILIO FOREIGN KEY(UTENSILIO_NOME)
                REFERENCES UTENSILIO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_UTENSILIO_FESTA CHECK(QUANTIDADE >= 0) --validando quantidade de utensilio necessitada, visto que deve ser um valor positivo
);*/

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
            System.out.println("Erro no UtensilioFesta_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return utensiliosFesta;
    }
    
    public String UtensilioFesta_Insert(UtensilioFesta utensilioFesta) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("INSERT INTO UTENSILIO_FESTA (FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE) "
                    + "VALUES (?, ?, ?)");
            
            pst.setInt(1, utensilioFesta.getFestaNroRegistro());
            pst.setString(2, utensilioFesta.getUtensilioNome());
            pst.setInt(3, utensilioFesta.getQuantidade());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Insert");
            return e.getMessage();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Insert");
            return e.getMessage();
        }
        
        ConnectionSGBD.CloseConnection(con);
        return "Utensilio_Festa inserido com sucesso";
    }
    
    public void Utensilio_Delete(UtensilioFesta utensilioFesta) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("DELETE FROM UTENSILIO_FESTA WHERE FESTA_NRO_REGISTRO = ? AND UTENSILIO_NOME = ?");                               
            
            pst.setInt(1, utensilioFesta.getFestaNroRegistro());
            pst.setString(2, utensilioFesta.getUtensilioNome());

            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void UtensilioFesta_Update(UtensilioFesta utensilioFesta, UtensilioFesta updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE UTENSILIO_FESTA "
                    + "SET QUANTIDADE = ?" +
                    "WHERE FESTA_NRO_REGISTRO = ? AND UTENSILIO_NOME = ?");

            pst.setInt(1, updated.getQuantidade());
            pst.setInt(2, utensilioFesta.getFestaNroRegistro());
            pst.setString(3, utensilioFesta.getUtensilioNome());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no UtensilioFesta_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
