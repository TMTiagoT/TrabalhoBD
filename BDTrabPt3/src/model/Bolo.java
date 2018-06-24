/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;


/*CREATE TABLE BOLO (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    CONSTRAINT PK_BOLO PRIMARY KEY(NOME),
    CONSTRAINT CK1_BOLO CHECK(PRECO >= 0)
);*/

<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class Bolo {
    private String nome;
    private String modelo;
    private double preco;
    private String descricao;

    public Bolo(String nome, String modelo, double preco, String descricao) {
        this.nome = nome;
        this.modelo = modelo;
        this.preco = preco;
        this.descricao = descricao;
    }

    @Override
    public String toString() {
        return "Bolo{" + "nome=" + nome + ", modelo=" + modelo + ", preco=" + preco + ", descricao=" + descricao + '}';
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }
}
