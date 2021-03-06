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
import model.FuncionarioFesta;

/*CREATE TABLE FUNCIONARIO_FESTA (
    FUNCIONARIO_CPF CHAR(14) NOT NULL,
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    PRECO_FUNCIONARIO NUMBER(12,2) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_FUNCIONARIO_FESTA PRIMARY KEY(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO), --chave primaria da tabela
    CONSTRAINT FK_FUNCIONARIO_FESTA_FUNC FOREIGN KEY(FUNCIONARIO_CPF)
                REFERENCES FUNCIONARIO(CPF)
                ON DELETE CASCADE,
    CONSTRAINT FK_FUNCIONARIO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT CK1_FUNCIONARIO_FESTA CHECK(PRECO_FUNCIONARIO >= 0) --checar a validade do preco do funcionario (tem que ser positivo)
);*/

public class FuncionarioFestaDB {
    
    /**
     *
     * @return
     */
    public ArrayList<FuncionarioFesta> FuncionarioFesta_SelectAll() {
        ArrayList<FuncionarioFesta> funcionariosFesta = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO FROM FUNCIONARIO_FESTA");

            while (rs.next()) {
                funcionariosFesta.add(new FuncionarioFesta(rs.getString(1), rs.getInt(2), rs.getDouble(3)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return funcionariosFesta;
    }
    
    public void Funcionario_Insert(FuncionarioFesta funcionarioFesta) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("INSERT INTO FUNCIONARIO (FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO) "
                    + "VALUES (?, ?, ?)");
            
            pst.setString(1, funcionarioFesta.getFuncionarioCpf());
            pst.setInt(2, funcionarioFesta.getFestaNroRegistro());
            pst.setDouble(3, funcionarioFesta.getPrecoFuncionario());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Funcionario_Delete(FuncionarioFesta funcionarioFesta) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("DELETE FROM FUNCIONARIO_Festa "
                    + "WHERE FUNCIONARIO_CPF = ? AND FESTA_NRO_REGISTRO = ?");                               
            
            pst.setString(1, funcionarioFesta.getFuncionarioCpf());
            pst.setInt(2, funcionarioFesta.getFestaNroRegistro());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no FuncionarioFesta_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void FuncionarioFesta_Update(FuncionarioFesta funcionarioFesta, FuncionarioFesta updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE FUNCIONARIO_FESTA "
                    + "SET PRECO_FUNCIONARIO = ? " +
                    "WHERE FUNCIONARIO_CPF = ? AND FESTA_NRO_REGISTRO = ?");

            pst.setDouble(1, updated.getPrecoFuncionario());
            pst.setString(2, funcionarioFesta.getFuncionarioCpf());
            pst.setInt(3, funcionarioFesta.getFestaNroRegistro());
            
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
