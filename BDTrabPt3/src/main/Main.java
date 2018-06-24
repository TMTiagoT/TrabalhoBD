/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import hud.TelaInicial;
import java.util.ArrayList;
import model.Cliente;
import model.Utensilio;
import sgbd.ClienteDB;
import sgbd.UtensilioDB;

public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
<<<<<<< HEAD
        ArrayList<Cliente> clientes = new ArrayList();
        ArrayList<Utensilio> utensilios = new ArrayList();
        
        ClienteDB clienteDB = new ClienteDB();
        clientes = clienteDB.Cliente_SelectAll();
        
        UtensilioDB utensilioDB = new UtensilioDB();
        utensilios = utensilioDB.Utensilio_SelectAll();
        
        for(Cliente c : clientes){
            System.out.println(c);
        }
        for (Utensilio u: utensilios) {
            System.out.println(u);
        }
=======
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
>>>>>>> master
   }
    
}
