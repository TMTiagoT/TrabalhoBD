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
                                    rs.getString("EMPRESA"), rs.getInt("TELEFONE1"), rs.getInt("TELEFONE2")));
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
            PreparedStatement pst = con.prepareStatement("INSERT INTO CLIENTE (CPF, NOME, EMAIL, EMPRESA, TELEFONE1, TELEFONE2) "
                    + "VALUES (?, ?, ?, ?, ?, ?)");
            
            pst.setString(1, cliente.getCpf());
            pst.setString(2, cliente.getNome());
            pst.setString(3, cliente.getEmail());
            pst.setString(4, cliente.getEmpresa());
            pst.setInt(5, cliente.getTelefone1());
            pst.setInt(6, cliente.getTelefone2());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Insert");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Insert");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
        
    public void Cliente_Delete(Cliente cliente) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("DELETE FROM CLIENTE WHERE CPF = ?");
            
             pst.setString(1, cliente.getCpf());
            
            pst.executeUpdate();
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Delete");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Delete");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    public void Cliente_Update(Cliente cliente, Cliente updated) {
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            PreparedStatement pst = con.prepareStatement("UPDATE CLIENTE "
                    + "SET NOME = ?, EMAIL = ?, EMPRESA = ?, TELEFONE1 = ?, TELEFONE2 = ? " +
                    "WHERE CPF = ?");

            pst.setString(1, updated.getNome());
            pst.setString(2, updated.getEmail());
            pst.setString(3, updated.getEmpresa());
            pst.setInt(4, updated.getTelefone1());
            pst.setInt(5, updated.getTelefone2());
            pst.setString(6, cliente.getCpf());
            
            pst.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Update");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Cliente_Update");
        }
        
        ConnectionSGBD.CloseConnection(con);
    }
    
    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
