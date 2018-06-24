/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/**
 *CREATE TABLE CLIENTE (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(48),
    EMPRESA VARCHAR2(40),
    TELEFONE1 CHAR(20) NOT NULL,
    TELEFONE2 CHAR(20),
    CONSTRAINT PK_CLIENTE PRIMARY KEY(CPF)
); */

public class Cliente {
    private String cpf;
    private String nome;
    private String email;
    private String empresa;
    private int telefone1;
    private int telefone2;

    public Cliente(String cpf, String nome, String email, String empresa, int telefone1, int telefone2) {
        this.cpf = cpf;
        this.nome = nome;
        this.email = email;
        this.empresa = empresa;
        this.telefone1 = telefone1;
        this.telefone2 = telefone2;
    }
    
    @Override
    public String toString() {
        return ("CPF: " + this.cpf + " \tNome: " + this.nome + " \tEmail: " + ((this.email == null) ? ("") : (this.email)) 
                + " \tEmpresa: " + ((this.empresa == null) ? ("") : (this.empresa)) + " \tTelefone 1: " + this.telefone1 
                + " \tTelefone 2: " + this.telefone2);
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmpresa() {
        return empresa;
    }

    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }

    public int getTelefone1() {
        return telefone1;
    }

    public void setTelefone1(int telefone1) {
        this.telefone1 = telefone1;
    }

    public int getTelefone2() {
        return telefone2;
    }

    public void setTelefone2(int telefone2) {
        this.telefone2 = telefone2;
    }
    
}
