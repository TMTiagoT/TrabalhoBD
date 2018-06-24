/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hud.selects;

import hud.festa.*;
import hud.cliente.*;
import java.util.ArrayList;
import javax.swing.table.DefaultTableModel;
import model.Cliente;
import sgbd.ClienteDB;

/**
 *
 * @author thiago
 */
public class TelaSelecionarTCliente extends javax.swing.JInternalFrame {
    ArrayList<Cliente> clientes;
    
    /**
     * Creates new form TelaInicialInterna
     */
    public TelaSelecionarTCliente() {
        initComponents();
    }
    
    public void listarClientes() {
        ClienteDB clientedb = new ClienteDB();
        clientes = clientedb.Cliente_SelectAll();
        
        DefaultTableModel t = (DefaultTableModel) jTable1.getModel();
        
        for (Cliente c : clientes) {
            t.addRow(new Object[]{c.getCpf(), c.getNome(), c.getEmail(), c.getEmpresa(), c.getTelefone1(), c.getTelefone2()});
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();

        setClosable(true);
        setIconifiable(true);

        jLabel1.setText("CLIENTES");

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "CPF_CLIENTE", "NOME_CLIENTE", "EMAIL_CLIENTE", "EMPRESA_CLIENTE", "TELEFONE1_CLIENTE", "TELEFONE2_CLIENTE"
            }
        ));
        jScrollPane1.setViewportView(jTable1);
        jTable1.getAccessibleContext().setAccessibleName("tabelacliente");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 680, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(layout.createSequentialGroup()
                .addGap(298, 298, 298)
                .addComponent(jLabel1)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 21, Short.MAX_VALUE)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 281, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables
}
