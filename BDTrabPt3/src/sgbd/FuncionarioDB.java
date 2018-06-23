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
import model.Funcionario;

/*CREATE TABLE FUNCIONARIO (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(60),
    TELEFONE1 NUMBER(20) NOT NULL,
    TELEFONE2 NUMBER(20),
    FUNCAO CHAR(32) NOT NULL,
    FUNCIONARIO_GERENTE_CPF CHAR(14),
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(CPF),
    CONSTRAINT FK_FUNCIONARIO_FUNCIONARIO FOREIGN KEY(FUNCIONARIO_GERENTE_CPF)
                REFERENCES FUNCIONARIO(CPF)
                ON DELETE SET NULL,
    CONSTRAINT CK1_FUNCIONARIO CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}')),
    CONSTRAINT CK2_FUNCIONARIO CHECK(EMAIL IS NULL OR EMAIL LIKE '_%@_%._%'),
    CONSTRAINT CK3_FUNCIONARIO CHECK(TELEFONE1 >= 0),
    CONSTRAINT CK4_FUNCIONARIO CHECK(TELEFONE2 IS NULL OR TELEFONE2 >= 0)
);*/

/**
 *
 * @author andre
 */
public class FuncionarioDB {
    
    /**
     *
     * @return
     */
    public ArrayList<Funcionario> Funcionario_SelectAll() {
        ArrayList<Funcionario> funcionarios = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT CPF, NOME, EMAIL, EMPRESA, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF FROM FUNCIONARIO");

            while (rs.next()) {
                funcionarios.add(new Funcionario(rs.getString(1), rs.getString(2), rs.getString(3),
                                    rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Funcionario_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Funcionario_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return funcionarios;
    }
    
}
