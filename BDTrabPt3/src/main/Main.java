/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import hud.TelaInicial;
import java.util.ArrayList;
import model.Cliente;
import sgbdCommands.ClienteDB;

public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
//        ArrayList<Cliente> clientes = new ArrayList();
//        
//        ClienteDB clienteDB = new ClienteDB();
//        clientes = clienteDB.Cliente_SelectAll();
//        
//        for(Cliente c : clientes){
//            System.out.println(c);
//        }
        
        TelaInicial telaInicial = new TelaInicial();
        telaInicial.setVisible(true);
   }
    
}
