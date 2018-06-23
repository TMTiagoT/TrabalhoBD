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
import model.Cliente;

public class ClienteDB {

    //selecionar todos os clientes
    public ArrayList<Cliente> Cliente_SelectAll() {
        ArrayList<Cliente> clientes = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT CPF, NOME, EMAIL, EMPRESA, TELEFONE1, TELEFONE2 FROM CLIENTE");

            while (rs.next()) {
                clientes.add(new Cliente(rs.getString("CPF"), rs.getString("NOME"), rs.getString("EMAIL"),
                                    rs.getString("EMPRESA"), rs.getString("TELEFONE1"), rs.getString("TELEFONE2")));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return clientes;
    }
    
    
    public void Cliente_Insert(Cliente cliente) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("INSERT INTO (CLIENTE CPF, NOME, EMAIL, EMPRESA, TELEFONE1, TELEFONE2)"
                    + "VALUES (" + cliente.getCpf() + ", " + cliente.getNome() + ", " + cliente.getEmail() + ", " + cliente.getEmpresa() + ", " + cliente.getTelefone1() + ", " + cliente.getTelefone2());
            
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
